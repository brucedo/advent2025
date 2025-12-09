defmodule Day9 do
  def run_problem() do
    IO.puts("Starting Day 9, part 1")

    lines =
      Common.open(File.cwd(), "day9")
      |> Common.read_file_pipe()
      |> Common.close()

    part_1_answer = run_part_1(lines)

    IO.puts("Part 1 answer appears to be #{part_1_answer}")
  end

  def run_part_1(lines) do
    points = lines |> Enum.map(&form_point/1)

    run_part_1_iter(points)
  end

  defp run_part_1_iter([_next_point | []]) do
    -1
  end

  defp run_part_1_iter([next_point | remaining]) do
    max(max_area(next_point, remaining), run_part_1_iter(remaining))
  end

  def area({corner_1_x, corner_1_y}, {corner_2_x, corner_2_y}) do
    (abs(corner_1_x - corner_2_x) + 1) * (abs(corner_1_y - corner_2_y) + 1)
  end

  def max_area(_constant, []) do
    -1
  end

  def max_area(constant, [next | rest]) do
    max(area(constant, next), max_area(constant, rest))
  end

  def form_point(line) do
    String.trim(line)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
