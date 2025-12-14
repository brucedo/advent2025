defmodule Visited do
  require Logger
  use Agent

  def start_link() do
    # Logger.debug("Empty start link for Visited called")
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)
  end

  def start_link(keys) do
    # Logger.debug("Parameterized start link for Visited called: #{inspect(keys)}")
    Agent.start_link(fn -> MapSet.new(keys) end, name: __MODULE__)
  end

  def visited?(key) do
    Agent.get(__MODULE__, fn map_set ->
      # Logger.debug("Visited: #{inspect(map_set)}")
      MapSet.member?(map_set, key)
    end)
  end

  def visit(key) do
    Agent.update(__MODULE__, fn map_set -> MapSet.put(map_set, key) end)
  end

  def stop_link() do
    Agent.stop(__MODULE__)
  end
end

defmodule JoltMap do
  require Logger
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def start_link(%{width: width, toggles: toggles}) do
    Agent.start_link(fn -> %{width: width, toggles: toggles, jolt_history: %{}} end,
      name: __MODULE__
    )
  end

  def next_generation(jolt) do
    Agent.get(__MODULE__, fn state ->
      #   width: width,
      #   toggles: toggles,
      #   jolt_history: jolt_history
      # } ->
      # Logger.debug("Current state: #{inspect(state)}")
      # jolt_history = Map.get(state, :jolt_history)
      toggles = Map.get(state, :toggles)

      Enum.map(toggles, &construct_jolts(jolt, &1))

      # {jolts,
      #  %{width: width, toggles: toggles, jolt_so_far: Map.put(jolt_history, jolt, jolts)}}

      # {jolts, %{width: width, toggles: toggles, jolt_history: jolt_history}}
    end)
  end

  def construct_jolts(jolt, toggle) do
    Enum.reduce(toggle, jolt, fn toggle_index, jolt ->
      put_elem(jolt, toggle_index, elem(jolt, toggle_index) + 1)
    end)
  end

  def stop_link() do
    Agent.stop(__MODULE__)
  end
end

defmodule LightMap do
  require Logger
  use Agent
  import Bitwise

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def start_link(%{width: width, toggles: toggles}) do
    light_perms = permute_lights(width)

    initial_state =
      Enum.reduce(light_perms, %{}, fn permutation, acc ->
        toggled_sets =
          Enum.reduce(toggles, %{}, fn toggle, acc ->
            Map.put(acc, LightMap.make_toggle(toggle), nil)
          end)

        Map.put(acc, permutation, toggled_sets)
      end)

    # Logger.debug("Initial state: #{inspect(initial_state)}")

    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def permute_lights(0) do
    [0]
  end

  def permute_lights(light_count) do
    false_branches =
      for branch <- permute_lights(light_count - 1) do
        # Logger.debug("false branch: #{inspect(branch)}")
        branch <<< 1
      end

    true_branches =
      for branch <- permute_lights(light_count - 1) do
        # Logger.debug("true branch: #{inspect(branch)}")
        (branch <<< 1) + 1
      end

    # Logger.debug("#{inspect(false_branches)}, #{inspect(true_branches)}")

    false_branches ++ true_branches
  end

  def toggles(bit_pattern) do
    # Logger.debug("Started LightMap.toggles")

    toggles =
      Agent.get(__MODULE__, fn state ->
        # Logger.debug("state of LightMap during toggles: #{inspect(state)}")
        Map.get(state, bit_pattern)
      end)

    bit_flips = Map.keys(toggles)

    # Logger.debug("Bit flips is: #{inspect(bit_flips)}")
    # Logger.debug("Toggles is: #{inspect(toggles)}")

    case Map.values(toggles) |> Enum.all?(fn submap -> submap == nil end) do
      true ->
        new_toggles =
          Enum.reduce(bit_flips, toggles, fn flip, acc ->
            Map.put(acc, flip, bxor(bit_pattern, flip))
          end)

        # Logger.debug("freshly created toggles: #{inspect(new_toggles)}")

        Agent.get_and_update(__MODULE__, fn state ->
          {new_toggles, Map.put(state, bit_pattern, new_toggles)}
        end)

      # new_toggles

      false ->
        # Logger.debug("Apparently we have these toggles already: #{inspect(toggles)}")
        Map.values(toggles)
    end

    for flip <- bit_flips, do: bxor(bit_pattern, flip)
  end

  def make_toggle([]) do
    0
  end

  def make_toggle([bit_index | rest]) do
    bit_pattern = make_toggle(rest)

    toggle_bit = 1 <<< bit_index

    bxor(bit_pattern, toggle_bit)
  end

  def stop_link() do
    Agent.stop(__MODULE__)
  end
end

defmodule Day10 do
  require Logger

  def run_problem() do
    IO.puts("Starting Day 10, part 1")

    lines =
      Common.open(File.cwd(), "day10")
      |> Common.read_file_pipe()
      |> Common.close()

    total = run_part_1(lines)

    IO.puts("The total for part 1 is supposedly #{total}")
  end

  def run_part_2(lines) do
    Enum.map(lines, &decode_line/1)
    |> Enum.map(fn {_, toggle_str, jolts} -> {into_toggles(toggle_str), decode_jolts(jolts)} end)
    |> Enum.map(&run_one_machine_part_2/1)
    |> Enum.sum()
  end

  def run_one_machine_part_2({toggles, target_jolts}) do
    # Logger.debug("Starting run_one_machine_part_2")
    width = tuple_size(target_jolts)
    starting_jolts = starting_jolts(width)

    # Logger.debug("width: #{width}")
    # Logger.debug("Starting jolts: #{inspect(starting_jolts)}")

    Visited.start_link()
    JoltMap.start_link(%{width: width, toggles: toggles})

    starting_generation =
      JoltMap.next_generation(starting_jolts)
      |> Enum.map(fn jolt ->
        Visited.visit(jolt)
        {1, jolt}
      end)

    # Logger.debug("Starting generation: #{inspect(starting_generation)}")

    result = part_2_iter(target_jolts, starting_generation)

    # Logger.debug("Result: #{result}")

    Visited.stop_link()
    JoltMap.stop_link()

    result
  end

  defp part_2_iter(target_jolt, [{current_generation, current_jolt} | _rest])
       when target_jolt == current_jolt do
    # Logger.debug("Found a solution: #{current_generation}")
    current_generation
  end

  defp part_2_iter(target_jolt, [{current_generation, current_jolt} | rest]) do
    # Logger.debug("Starting the next search in part_2_iter")
    # Logger.debug("target_jolt: #{inspect(target_jolt)}")
    # Logger.debug("Current generation: #{inspect(current_generation)}")
    # Logger.debug("Current jolts: #{inspect(current_jolt)}")

    next_generation =
      JoltMap.next_generation(current_jolt)

    # Logger.debug("Next gen: #{inspect(next_generation)}")
    temp = Enum.filter(next_generation, &(!Visited.visited?(&1)))
    # Logger.debug("Filtered for visited: #{inspect(temp)}")
    temp = Enum.filter(temp, &piecewise_jolts(&1, target_jolt))
    # Logger.debug("Filtered for exceeding target: #{inspect(temp)}")
    temp = Enum.map(temp, fn new_jolt -> {current_generation + 1, new_jolt} end)
    # Logger.debug("mapped to new form: #{inspect(temp)}")

    part_2_iter(target_jolt, temp ++ rest)
  end

  defp piecewise_jolts(left, right) do
    reduced =
      Enum.reduce(0..(tuple_size(left) - 1), true, fn index, acc ->
        acc && elem(left, index) <= elem(right, index)
      end)

    # Logger.debug("#{inspect(left)} vs #{inspect(right)}: #{reduced}")
    reduced
  end

  def starting_jolts(jolt_count) do
    Tuple.duplicate(0, jolt_count)
  end

  def decode_jolts(jolts_str) do
    String.split(jolts_str, ",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def run_part_1(lines) do
    Enum.map(lines, &decode_line/1)
    |> Enum.map(fn {target_state, toggle_str, power} ->
      {target_state, into_toggles(toggle_str), power}
    end)
    |> Enum.map(&run_one_machine_part_1/1)
    |> Enum.sum()
  end

  @spec run_one_machine_part_1({String.t(), list(list(number())), String.t()}) :: number()
  def run_one_machine_part_1({target_state_str, toggles, _}) do
    # Logger.debug("entered run_one_machine_part_1")
    # Logger.debug("target state: #{target_state_str}")
    # Logger.debug("Toggles: #{inspect(toggles)}")

    light_count = String.length(target_state_str)
    target_pattern = light_pattern(target_state_str) |> LightMap.make_toggle()

    # Logger.debug("Target pattern post transformn: #{inspect(target_pattern)}")

    LightMap.start_link(%{width: light_count, toggles: toggles})
    Visited.start_link()

    start_pattern = 0

    found_depth = walk_patterns(target_pattern, [{0, start_pattern}])

    LightMap.stop_link()

    Visited.stop_link()

    found_depth
  end

  defp walk_patterns(target_pattern, [{depth, pattern} | _rest]) when target_pattern == pattern do
    # Logger.debug("Found a match at depth #{depth}")
    depth
  end

  defp walk_patterns(target_pattern, [{depth, pattern} | rest]) do
    # Logger.debug("entered walk_patterns")
    # Logger.debug("target pattern: #{inspect(target_pattern)}")
    # Logger.debug("current depth: #{depth}")
    # Logger.debug("current pattern: #{pattern}")

    unchecked_patterns =
      LightMap.toggles(pattern)
      |> Enum.filter(&(!Visited.visited?(&1)))

    unchecked_patterns |> Enum.each(&Visited.visit/1)

    # Logger.debug("Unchecked patterns: #{inspect(unchecked_patterns)}")

    all_unchecked =
      rest ++ Enum.map(unchecked_patterns, fn new_pattern -> {depth + 1, new_pattern} end)

    walk_patterns(target_pattern, all_unchecked)
  end

  def decode_line(line) do
    [pattern_parts | rest] = String.split(line)

    {toggles, power} = toggles_and_power(rest)

    {String.slice(pattern_parts, 1..-2//1), toggles, power}
  end

  defp toggles_and_power([power | []]) do
    {[], String.slice(power, 1..-2//1)}
  end

  defp toggles_and_power([toggle | rest]) do
    {toggles, power} = toggles_and_power(rest)

    {[String.slice(toggle, 1..-2//1) | toggles], power}
  end

  def into_toggles(toggle_sequence) do
    Enum.map(toggle_sequence, fn toggles ->
      String.split(toggles, ",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def light_pattern(light_pattern) do
    String.codepoints(light_pattern)
    |> Enum.with_index()
    |> Enum.filter(fn {pattern, _index} -> pattern == "#" end)
    |> Enum.map(fn {_pattern, index} -> index end)
  end

  def filter_by_visited(lights) do
    Enum.filter(lights, fn light -> !Visited.visited?(light) end)
  end
end
