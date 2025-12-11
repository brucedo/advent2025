defmodule TileSegments do
  require Logger
  use Agent

  def start_link([first_point | remaining]) do
    sorted_segments =
      create_line_segments(first_point, remaining)
      |> sort_points_by_x_axis()

    # Logger.debug("sorted segments: #{inspect(sorted_segments, charlists: :as_lists)}")

    Agent.start_link(fn -> sorted_segments end, name: __MODULE__)
  end

  defp sort_points_by_x_axis(segments) do
    segments
    |> Enum.group_by(fn {_, {start_x, _}, _} -> start_x end)
    |> Map.to_list()
    |> Enum.sort(fn {left_x, _}, {right_x, _} -> left_x <= right_x end)
  end

  defp create_line_segments(first_point, [unmatched | []]) do
    case elem(first_point, 0) == elem(unmatched, 0) do
      true -> [create_segment_from_points(unmatched, first_point)]
      false -> []
    end
  end

  defp create_line_segments(first_point, [first | [second | rest]]) do
    case elem(first, 0) == elem(second, 0) do
      # Vertical line
      true ->
        [
          create_segment_from_points(first, second)
          | create_line_segments(first_point, [second | rest])
        ]

      # Horizontal line
      false ->
        create_line_segments(first_point, [second | rest])
    end
  end

  defp create_segment_from_points(first, second) do
    case elem(first, 0) == elem(second, 0) do
      true ->
        direction =
          case elem(first, 1) < elem(second, 1) do
            true -> :down
            false -> :up
          end

        {direction, first, second}

      false ->
        {:error, "This should only be used on vertical line segments."}
    end
  end

  def inside?(point) do
    Agent.get(__MODULE__, fn segments ->
      search_state(:outside, point, segments)
    end)
  end

  defp search_state(_, _, []) do
    # Logger.debug("Have exhausted all columns, returning false.")
    false
  end

  defp search_state(:outside, {x, y}, [{segment_column, segments} | unchecked]) do
    # Logger.debug(":outside, #{x}, #{y}, for column #{segment_column}")

    case x < segment_column do
      true ->
        # Logger.debug("remaining segment x coords are bigger than x.  It is forever outside.")
        false

      false ->
        # Logger.debug("this segment x coord is less than x.  Is it beside a segment?")

        case segment_search(:outside, y, segments) do
          true -> search_state(:inside, {x, y}, unchecked)
          false -> search_state(:outside, {x, y}, unchecked)
        end
    end
  end

  defp search_state(:inside, {x, y}, [{segment_column, segments} | unchecked]) do
    # Logger.debug(":inside, #{x}, #{y}, for column #{segment_column}")

    case x <= segment_column do
      true ->
        # Logger.debug("We're inside and we have exhausted all columns left of x.  We are inside.")
        true

      false ->
        # Logger.debug("We're inside and need to check for down columns to our left.")

        case segment_search(:inside, y, segments) do
          true -> search_state(:outside, {x, y}, unchecked)
          false -> search_state(:inside, {x, y}, unchecked)
        end
    end
  end

  defp segment_search(_, _, []) do
    false
  end

  defp segment_search(:outside, point_y, [
         {direction, {_, start_y}, {_, end_y}} | remaining_segments
       ]) do
    cond do
      direction == :up && start_y >= point_y && point_y >= end_y -> true
      true -> segment_search(:outside, point_y, remaining_segments)
    end
  end

  defp segment_search(:inside, point_y, [
         {direction, {_, start_y}, {_, end_y}} | remaining_segments
       ]) do
    cond do
      direction == :down && start_y <= point_y && point_y <= end_y -> true
      true -> segment_search(:inside, point_y, remaining_segments)
    end
  end
end

defmodule Day92 do
  require Logger

  def run_problem() do
    IO.puts("Starting Day 9, part 2")

    lines =
      Common.open(File.cwd(), "day9")
      |> Common.read_file_pipe()
      |> Common.close()

    red_tile_coords = parse_coords(lines)

    Logger.debug("Starting segmentification")
    TileSegments.start_link(red_tile_coords)
    Logger.debug("Done segmentification")

    part_2_answer = run_part_2(red_tile_coords)

    IO.puts("Part 2 answer is supposedly #{part_2_answer}")
  end

  def run_part_2(red_tile_coords) do
    Logger.debug("Reading in the filtered squares")
    filtered_squares = filter_unmakeable(red_tile_coords)

    Logger.debug("filtering by border inclusion")

    filtered_squares = filter_by_border(filtered_squares)

    Logger.debug("Calculating area")
    max_area(filtered_squares)
  end

  def parse_coords(lines) do
    lines
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [x_str | [y_str | []]] ->
      {String.to_integer(x_str), String.to_integer(y_str)}
    end)
  end

  def filter_by_border([]) do
    []
  end

  def filter_by_border([{{first_x, first_y}, {second_x, second_y}} | filtered_squares]) do
    {small_x, large_x} =
      case first_x < second_x do
        true -> {first_x, second_x}
        false -> {second_x, first_x}
      end

    {small_y, large_y} =
      case first_y < second_y do
        true -> {first_y, second_y}
        false -> {second_y, first_y}
      end

    case filter_along_x(large_x, small_x, small_y) && filter_along_x(large_x, small_x, large_y) &&
           filter_along_y(large_y, small_y, small_x) && filter_along_y(large_y, small_y, large_x) do
      true -> [{{first_x, first_y}, {second_x, second_y}} | filter_by_border(filtered_squares)]
      false -> filter_by_border(filtered_squares)
    end
  end

  defp filter_along_y(second_y, current_y, x) when second_y == current_y do
    TileSegments.inside?({x, current_y})
  end

  defp filter_along_y(second_y, current_y, x) do
    case TileSegments.inside?({x, current_y}) do
      true ->
        filter_along_y(second_y, current_y + 1, x)

      false ->
        # Logger.debug("At least one pair {#{x}, #{current_y}} is not inside")
        false
    end
  end

  defp filter_along_x(second_x, current_x, y) when second_x == current_x do
    TileSegments.inside?({current_x, y})
  end

  defp filter_along_x(second_x, current_x, y) do
    case TileSegments.inside?({current_x, y}) do
      true ->
        filter_along_x(second_x, current_x + 1, y)

      false ->
        # Logger.debug("At least one pair {#{current_x}, #{y} } is not inside")
        false
    end
  end

  def filter_unmakeable([]) do
    []
  end

  def filter_unmakeable([next | rest]) do
    compare_sublist(next, rest) ++ filter_unmakeable(rest)
  end

  defp compare_sublist(_first, []) do
    []
  end

  defp compare_sublist({first_x, first_y}, [{second_x, second_y} | rest]) do
    case TileSegments.inside?({first_x, second_y}) && TileSegments.inside?({second_x, first_y}) do
      true ->
        [{{first_x, first_y}, {second_x, second_y}} | compare_sublist({first_x, first_y}, rest)]

      false ->
        compare_sublist({first_x, first_y}, rest)
    end
  end

  def max_area([]) do
    -1
  end

  def max_area([{{first_x, first_y}, {second_x, second_y}} | remaining]) do
    area = (abs(first_x - second_x) + 1) * (abs(first_y - second_y) + 1)

    max(area, max_area(remaining))
  end
end
