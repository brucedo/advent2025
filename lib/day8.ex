defmodule CircuitTracker do
  require Logger
  use Agent

  def start_link() do
    # Logger.debug("Parameterless start_link")
    Agent.start_link(fn -> {0, %{}} end, name: __MODULE__)
  end

  def start_link(initial_state) do
    # Logger.debug("Parameterized start_link")
    length = Map.values(initial_state) |> length()
    Agent.start_link(fn -> {length, initial_state} end, name: __MODULE__)
  end

  def join_circuits({left_index, right_indx}) do
    next_index = UniqueCounting.next()

    # Logger.debug(
    #   "Left and right index in join_circuits: #{inspect(left_index)}, #{inspect(right_indx)}"
    # )

    case left_index == right_indx do
      true ->
        {left_index, []}

      false ->
        Agent.get_and_update(
          __MODULE__,
          fn {length, state} ->
            # Logger.debug("Joining circuits #{left_index} and #{right_indx}")
            # Logger.debug("Pulling from state #{inspect(state, charlists: :as_lists)}")
            {left_circuit, state} = Map.pop(state, left_index)
            {right_circuit, state} = Map.pop(state, right_indx)
            new_circuit = left_circuit ++ right_circuit
            state = Map.put(state, next_index, new_circuit)
            # Pop two circuits, put one back - net change -1
            length = length - 1
            # Logger.debug("Length after circuit merge: #{length}")
            {{next_index, new_circuit}, {length, state}}
          end
        )
    end
  end

  def all_connected?() do
    Agent.get(__MODULE__, fn {length, _state} -> length == 1 end)
  end

  def restart_with(initial_junctions) do
    Agent.update(__MODULE__, fn _state ->
      length = length(initial_junctions)

      {length,
       Enum.reduce(initial_junctions, %{}, fn junction, acc ->
         Map.put(acc, junction, [junction])
       end)}
    end)
  end

  def n_largest_circuits(n) do
    Agent.get(__MODULE__, fn {_length, state} ->
      # Logger.debug("Inspecting the largest circuits: #{inspect(state, charlists: :as_lists)}")

      Map.values(state)
      |> Enum.sort(fn left, right -> length(left) >= length(right) end)
      |> Enum.take(n)
    end)
  end

  def circuit_members_of(id) do
    Agent.get(__MODULE__, fn {_length, state} -> Map.get(state, id) end)
  end

  def stop() do
    Agent.stop(__MODULE__)
  end

  def stop(pid) do
    Agent.stop(pid)
  end
end

defmodule JunctionTracker do
  require Logger
  use Agent

  def start_link() do
    # Logger.debug("Start link for JT with no state")
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def start_link(initial_state) do
    # Logger.debug("Start link for JT with state #{inspect(initial_state)}")
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def retrieve_circuit_id(for_junction) do
    Agent.get(__MODULE__, fn state -> Map.get(state, for_junction) end)
  end

  def retrieve_circuit_ids({left_junction, right_junction}) do
    # Logger.debug("Junction ids: #{left_junction}, #{right_junction}")

    Agent.get(__MODULE__, fn state ->
      # Logger.debug("Presented state: #{inspect(state)}")

      case {Map.get(state, left_junction), Map.get(state, right_junction)} do
        {nil, nil} -> {}
        anything_else -> anything_else
      end
    end)
  end

  def update_junctions({new_circuit_id, affected_junctions}) do
    Agent.update(__MODULE__, fn state ->
      # Logger.debug("id: #{new_circuit_id}")
      # Logger.debug("Affected junctions: #{inspect(affected_junctions)}")

      Enum.reduce(affected_junctions, state, fn next_junction, acc ->
        Map.put(acc, next_junction, new_circuit_id)
      end)
    end)
  end

  def stop() do
    Agent.stop(__MODULE__)
  end
end

defmodule Day8 do
  require Logger

  def run_problem() do
    IO.puts("Starting Day 8, part 1")

    lines =
      Common.open(File.cwd(), "day8")
      |> Common.read_file_pipe()
      |> Common.close()

    numbers =
      Enum.map(lines, &String.split(&1, ","))
      |> Enum.map(fn [first | [second | [third | []]]] ->
        # Logger.debug("#{first}, #{second}, #{third}")
        {String.to_integer(first), String.to_integer(second), String.to_integer(third)}
      end)

    part_1_solution = run_part_1(numbers, 1000)

    IO.puts("Well this is a long shot but it's supposedly #{part_1_solution}")

    stop_agents()

    part_2_solution = run_part_2(numbers)

    IO.puts("this is going to be a disaster: #{part_2_solution}")
  end

  def run_part_1(boxes, iterations) do
    junction_to_id_map = junction_id(boxes)

    initialize_agents(junction_to_id_map)

    sorted_junction_ids = sort_dist(boxes) |> swap_junction_to_id(junction_to_id_map)

    part_1_iter(iterations, sorted_junction_ids)

    three_largest_circuits = CircuitTracker.n_largest_circuits(3)

    # Logger.debug(
    # "Three largest circuits: #{inspect(three_largest_circuits, charlists: :as_lists)}"
    # )

    Enum.map(three_largest_circuits, fn circuit -> length(circuit) end)
    |> Enum.product()
  end

  def run_part_2(boxes) do
    {{left_x, _, _}, {right_x, _, _}} = run_to_final_boxes(boxes)

    left_x * right_x
  end

  def run_to_final_boxes(boxes) do
    junction_to_id_map = junction_id(boxes)
    id_to_junction_map = map_id(boxes)

    initialize_agents(junction_to_id_map)

    sorted_junction_ids = sort_dist(boxes) |> swap_junction_to_id(junction_to_id_map)

    # Logger.debug("Inspecting the sorted junction ids: #{inspect(sorted_junction_ids)}")

    {left_index, right_index} = part_2_iter(sorted_junction_ids)

    {Map.get(id_to_junction_map, left_index), Map.get(id_to_junction_map, right_index)}
  end

  defp part_1_iter(0, _) do
  end

  defp part_1_iter(countdown, [{_dist, next_left, next_right} | rest]) do
    # Logger.debug("Starting a new iteration")
    # Logger.debug("Countdown: #{countdown}")
    # Logger.debug("next_left: #{inspect(next_left)}")
    # Logger.debug("next_right: #{inspect(next_right)}")
    left_and_right_ids = JunctionTracker.retrieve_circuit_ids({next_left, next_right})
    # Logger.debug("left and right ids: #{inspect(left_and_right_ids)}")

    next_index_and_affected_junctions = CircuitTracker.join_circuits(left_and_right_ids)

    # Logger.debug(
    # "next_index_and_affected_junctions: #{inspect(next_index_and_affected_junctions)}"
    # )

    JunctionTracker.update_junctions(next_index_and_affected_junctions)

    part_1_iter(countdown - 1, rest)
  end

  # defp part_2_iter([]) do
  #   IO.puts(
  #     "Something has gone really fucking weird.  There should be no way we have empty list as a parameter."
  #   )
  # end

  defp part_2_iter([{_dist, next_left, next_right} | rest]) do
    # Logger.debug("Next left and next right: #{next_left}, #{next_right}")
    # Logger.debug("And what's left: #{inspect(rest, charlists: :as_lists)}")
    left_and_right_ids = JunctionTracker.retrieve_circuit_ids({next_left, next_right})
    # Logger.debug("Circuit IDs: #{inspect(left_and_right_ids)}")
    next_index_and_affected_junctions = CircuitTracker.join_circuits(left_and_right_ids)
    JunctionTracker.update_junctions(next_index_and_affected_junctions)

    # Logger.debug("What the fuck.  rest: #{inspect(rest)}")

    case CircuitTracker.all_connected?() do
      true -> {next_left, next_right}
      false -> part_2_iter(rest)
    end
  end

  defp initialize_agents(junction_to_id_map) do
    junction_to_id_map
    |> Map.values()
    |> Enum.reduce(%{}, fn junction_id, acc -> Map.put(acc, junction_id, [junction_id]) end)
    |> CircuitTracker.start_link()

    junction_to_id_map
    |> Map.values()
    |> Enum.reduce(%{}, fn junction_id, acc -> Map.put(acc, junction_id, junction_id) end)
    |> JunctionTracker.start_link()

    UniqueCounting.start_link(length(Map.values(junction_to_id_map)) + 1)
  end

  defp stop_agents() do
    CircuitTracker.stop()
    JunctionTracker.stop()

    UniqueCounting.stop()
  end

  def create_circuit_map(junction_ids) do
    CircuitTracker.restart_with(junction_ids)
    # Enum.reduce(junction_ids, %{}, fn elem, acc -> Map.put(acc, elem, [elem]) end)
  end

  def create_junction_2_circuit(junction_ids) do
    Enum.reduce(junction_ids, %{}, fn elem, acc -> Map.put(acc, elem, elem) end)
  end

  def swap_junction_to_id(distances, ids) do
    Enum.map(distances, fn {distance, left_junction, right_junction} ->
      {distance, Map.get(ids, left_junction), Map.get(ids, right_junction)}
    end)
  end

  # def update_junctions({_, []}, junction_to_circuit) do
  #   junction_to_circuit
  # end
  #
  # def update_junctions({updated_circuit, [next | rest]}, junction_to_circuit) do
  #   update_junctions(
  #     {updated_circuit, rest},
  #     Map.replace(junction_to_circuit, next, updated_circuit)
  #   )
  # end

  # def retrieve_circuit_ids({left, right}, junctions_to_circuits) do
  #   {Map.get(junctions_to_circuits, left), Map.get(junctions_to_circuits, right)}
  # end

  # def join_junction({left, right}, circuit_to_index) do
  #   {UniqueCounting.next(), Map.get(circuit_to_index, left) ++ Map.get(circuit_to_index, right)}
  # end

  def junction_id(junctions) do
    Enum.with_index(junctions)
    |> Enum.reduce(%{}, fn {junction, index}, acc -> Map.put(acc, junction, index) end)
  end

  def map_id(junctions) do
    Enum.with_index(junctions)
    |> Enum.reduce(%{}, fn {junction, index}, acc -> Map.put(acc, index, junction) end)
  end

  def sort_dist([]) do
    []
  end

  def sort_dist(points) do
    dist_finder(points)
    |> Enum.sort(fn {left_distance, _, _}, {right_distance, _, _} ->
      left_distance <= right_distance
    end)
  end

  defp dist_finder([]) do
    []
  end

  defp dist_finder([next | rest]) do
    [subsort(next, rest) | dist_finder(rest)] |> List.flatten()
  end

  defp subsort(_current, []) do
    []
  end

  defp subsort(current, [next | rest]) do
    [{dist(current, next), current, next} | subsort(current, rest)]
  end

  def dist({left_x, left_y, left_z}, {right_x, right_y, right_z}) do
    :math.sqrt(
      :math.pow(left_x - right_x, 2) +
        :math.pow(left_y - right_y, 2) +
        :math.pow(left_z - right_z, 2)
    )
  end
end
