defmodule Day8 do
  def run_part_1(lines) do
    junctions =
      Enum.map(lines, &String.split(&1, ","))
      |> Enum.map(fn [x | [y | [z | []]]] ->
        {String.to_integer(x), String.to_integer(y), String.to_integer(z)}
      end)

    junction_index_map = junction_id(junctions)
    sorted_distances = sort_dist(junctions)
    sorted_junction_ids = swap_junction_to_id(sorted_distances, junction_index_map)
    circuit_2_junction_map = create_circuit_map(Map.values(junction_index_map))
    junction_2_circuit_map = create_junction_2_circuit(Map.values(junction_index_map))
  end

  defp join_junction_iter(0, _, circuit_2_junction, _) do
    circuit_2_junction
  end

  def join_junction_iter(
        n,
        [{_, left, right} | remaining_pairs],
        circuit_2_junction,
        junction_2_circuit
      ) do
    {left_circuit, right_circuit} = retrieve_circuits({left, right}, junction_2_circuit)

    case(left_circuit)
  end

  def create_circuit_map(junction_ids) do
    Enum.reduce(junction_ids, %{}, fn elem, acc -> Map.put(acc, elem, [elem]) end)
  end

  def create_junction_2_circuit(junction_ids) do
    Enum.reduce(junction_ids, %{}, fn elem(acc) -> Map.put(acc, elem, elem) end)
  end

  def swap_junction_to_id(distances, ids) do
    Enum.map(distances, fn {distance, left_junction, right_junction} ->
      {distance, Map.get(ids, left_junction), Map.get(ids, right_junction)}
    end)
  end

  def update_junctions({_, []}, junction_to_circuit) do
    junction_to_circuit
  end

  def update_junctions({updated_circuit, [next | rest]}, junction_to_circuit) do
    update_junctions(
      {updated_circuit, rest},
      Map.replace(junction_to_circuit, next, updated_circuit)
    )
  end

  def retrieve_circuits({left, right}, junctions_to_circuits) do
    {Map.get(junctions_to_circuits, left), Map.get(junctions_to_circuits, right)}
  end

  def join_junction({left, right}, circuit_to_index) do
    {UniqueCounting.next(), Map.get(circuit_to_index, left) ++ Map.get(circuit_to_index, right)}
  end

  def junction_id(junctions) do
    Enum.with_index(junctions)
    |> Enum.reduce(%{}, fn {junction, index}, acc -> Map.put(acc, junction, index) end)
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
