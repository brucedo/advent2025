defmodule Day2 do
  require Logger
  require Integer

  def run_problem() do
    IO.puts("Starting Day 2, part 1")

    lines =
      Common.open(File.cwd(), "day2")
      |> Common.read_file_pipe()
      |> Common.close()

    part_1_solution = run_part_1(lines)

    IO.puts("Part 1 solution: #{part_1_solution}")

    part_2_solution = run_part_2(lines)

    IO.puts("Part 2 solution: #{part_2_solution}")
  end

  def run_part_1(lines) do
    List.first(lines)
    |> String.split(",")
    |> Enum.map(&numberfy_range/1)
    |> Enum.flat_map(fn range ->
      Enum.filter(range, fn testable ->
        digits = Integer.to_string(testable) |> String.length()
        Integer.is_even(digits) && doubled?(testable, digits)
      end)
    end)
    |> Enum.reduce(&+/2)
  end

  def run_part_2(lines) do
    List.first(lines)
    |> String.split(",")
    |> Enum.map(&numberfy_range/1)
    |> Enum.flat_map(fn range ->
      Enum.filter(range, &repeats?/1)
    end)
    |> Enum.reduce(&+/2)
  end

  def doubled?(potential_id, length) do
    middle_power = Integer.floor_div(length, 2)
    divisor = Integer.pow(10, middle_power)

    upper = Integer.floor_div(potential_id, divisor)
    lower = Integer.mod(potential_id, divisor)

    upper == lower
  end

  def numberfy_range(range_expr) do
    range_tuple =
      String.split(range_expr, "-")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    elem(range_tuple, 0)..elem(range_tuple, 1)
  end

  def repeats?(number) do
    str_rep = Integer.to_string(number)
    rep_size = String.length(str_rep)
    max_divides = find_divisible_slice_sizes(rep_size)

    repeat_test(max_divides, str_rep, rep_size)
  end

  def repeat_test([], _, _) do
    # Logger.debug("Base case of the repeat test.")
    false
  end

  def repeat_test([current_divisor | rest], str_rep, rep_size) do
    slice_range = 0..(current_divisor - 1)

    # Logger.debug(
    #   "Test case of the repeat test.  Presenting: #{inspect(String.slice(str_rep, slice_range))}, #{inspect(current_divisor)}, #{inspect(str_rep)}, #{inspect(rep_size)}"
    # )

    case does_repeat?(
           String.slice(str_rep, slice_range),
           current_divisor,
           str_rep,
           rep_size
         ) do
      true -> true
      false -> repeat_test(rest, str_rep, rep_size)
    end
  end

  def does_repeat?(slice, slice_size, str_rep, rep_size) do
    String.duplicate(slice, Integer.floor_div(rep_size, slice_size)) == str_rep
  end

  def find_divisible_slice_sizes(rep_size) when rep_size <= 1 do
    []
  end

  def find_divisible_slice_sizes(rep_size) do
    1..Integer.floor_div(rep_size, 2)
    |> Enum.filter(fn chunk_size -> Integer.mod(rep_size, chunk_size) == 0 end)
  end
end
