defmodule Day7 do
  require Logger

  def run_problem_7() do
    IO.puts("Starting Day 7, part 1")

    lines =
      Common.open(File.cwd(), "day7")
      |> Common.read_file_pipe()
      |> Common.close()

    part_1_answer = run_part_1(lines)

    IO.puts("The answer for part 1 may well be #{part_1_answer}")

    part_2_answer = run_part_2(lines)

    IO.puts("the answer for part 2 may well be #{part_2_answer}")
  end

  def run_part_2([setup_line | rest]) do
    initial_state = parse_start(setup_line |> String.codepoints())

    last_round = walk_splitters(rest, initial_state)

    Enum.sum(last_round)
  end

  def walk_splitters([], current_state) do
    current_state
  end

  def walk_splitters([next_splitter_line | remaining_splitters], current_state) do
    next_state = evaluate_future(next_splitter_line, current_state)

    walk_splitters(remaining_splitters, next_state)
  end

  def parse_start([]) do
    []
  end

  def parse_start([next_char | line]) do
    case next_char do
      "S" -> [1 | parse_start(line)]
      _ -> [0 | parse_start(line)]
    end
  end

  def evaluate_future(splitter_line, previous_state) do
    divide_timelines(splitter_line, previous_state)
    |> group_indices()
    |> Enum.map(&sum_indexed_values/1)
    |> Enum.map(fn {_index, value} -> value end)
  end

  def group_indices(indices_and_values) do
    Enum.chunk_by(indices_and_values, fn {index, _value} -> index end)
  end

  def divide_timelines(splitter_line, timelines) do
    divide_timelines_iter(String.codepoints(splitter_line) |> Enum.with_index(), timelines)
  end

  def divide_timelines_iter([], []) do
    []
  end

  def divide_timelines_iter([{splitter_char, index} | remaining_splitters], [
        next_timeline | remaining_timelines
      ]) do
    Logger.debug("index: #{index}")
    Logger.debug("splitter char: #{splitter_char}")

    timeline_modifications =
      case splitter_char do
        "^" -> [{index - 1, next_timeline}, {index, 0}, {index + 1, next_timeline}]
        "." -> [{index, next_timeline}]
      end

    timeline_modifications ++ divide_timelines_iter(remaining_splitters, remaining_timelines)
  end

  def sum_indexed_values(summable) do
    Enum.reduce(summable, {-1, 0}, fn {index, value}, {_, acc} -> {index, value + acc} end)
  end

  def run_part_1(lines) do
    start_column = find_start_beam(hd(lines) |> String.codepoints() |> Enum.with_index())

    # Logger.debug("Start column: #{start_column}")

    splitter_map =
      Enum.map(lines, fn line ->
        String.codepoints(line) |> Enum.with_index() |> convert_to_columns
      end)

    # Logger.debug("Splitter map: #{inspect(splitter_map)}")

    run_simulation_part_1([start_column], splitter_map)
  end

  def run_simulation_part_1(_, []) do
    0
  end

  def run_simulation_part_1(beams, [next_splitter_row | rest_of_splitters]) do
    intersections = resolve_intersections(beams, next_splitter_row)
    surviving_beams = filter_beams(beams, next_splitter_row)
    new_beams = calculate_new_beams(intersections)

    next_beam_generation = merge_beams(surviving_beams, new_beams)

    length(intersections) + run_simulation_part_1(next_beam_generation, rest_of_splitters)
  end

  defp merge_beams([], []) do
    []
  end

  defp merge_beams(left_beams, []) do
    left_beams
  end

  defp merge_beams([], right_beams) do
    right_beams
  end

  defp merge_beams([next_left | left_beams], [next_right | right_beams]) do
    cond do
      next_left == next_right ->
        [next_left | merge_beams(left_beams, right_beams)]

      next_left > next_right ->
        [next_right | merge_beams([next_left | left_beams], right_beams)]

      next_left < next_right ->
        [next_left | merge_beams(left_beams, [next_right | right_beams])]
    end
  end

  def find_start_beam([{character, index} | rest]) do
    case character == "S" do
      true -> index
      false -> find_start_beam(rest)
    end
  end

  defp convert_to_columns([]) do
    []
  end

  defp convert_to_columns([{character, index} | rest]) do
    case character == "^" do
      true -> [index | convert_to_columns(rest)]
      false -> convert_to_columns(rest)
    end
  end

  def calculate_new_beams([]) do
    []
  end

  def calculate_new_beams([next_splitter | rest_splitters]) do
    left_beam = next_splitter - 1
    right_beam = next_splitter + 1

    # Logger.debug("Testing splitter at column #{next_splitter}")

    case calculate_new_beams(rest_splitters) do
      [] ->
        [left_beam, right_beam]

      [next_new_beam | remaining_beams] when next_new_beam == right_beam ->
        [left_beam | [next_new_beam | remaining_beams]]

      new_beams ->
        [left_beam | [right_beam | new_beams]]
    end
  end

  def filter_beams([], _) do
    []
  end

  def filter_beams([next_beam | remaining_beams], next_line) do
    case test_single_beam(next_beam, next_line) do
      {:ok, _beam} -> filter_beams(remaining_beams, next_line)
      {:error} -> [next_beam | filter_beams(remaining_beams, next_line)]
    end
  end

  def resolve_intersections([], _) do
    []
  end

  def resolve_intersections([next_beam | remaining_beams], next_line) do
    # Logger.debug("Inspecting beam column #{next_beam}")

    case test_single_beam(next_beam, next_line) do
      {:ok, beam} -> [beam | resolve_intersections(remaining_beams, next_line)]
      {:error} -> resolve_intersections(remaining_beams, next_line)
    end
  end

  defp test_single_beam(_beam, []) do
    # Logger.debug("splitter set emptied")
    {:error}
  end

  defp test_single_beam(beam, [next_splitter | remaining]) do
    # Logger.debug(
    #   "splitter: #{next_splitter}, beam: #{beam}, beam == next_splitter #{inspect(beam == next_splitter)}"
    # )

    # Logger.debug("what the fuck is in remaining #{inspect(remaining, charlists: :as_lists)}")

    case beam == next_splitter do
      true -> {:ok, beam}
      false -> test_single_beam(beam, remaining)
    end
  end
end
