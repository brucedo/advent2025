defmodule Day3 do
  require Logger

  def run_problem() do
    IO.puts("Starting Day 3, part 1")

    lines =
      Common.open(File.cwd(), "day3")
      |> Common.read_file_pipe()
      |> Common.close()

    part_1_answer = run_part_1(lines)

    IO.puts("Supposedly part 1 is #{inspect(part_1_answer)}")

    part_2_answer = run_part_2(lines)

    IO.puts("Supposedly part 2 is #{inspect(part_2_answer)}")
  end

  def run_part_2(lines) do
    lines
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(fn str_nums -> Enum.map(str_nums, &String.to_integer/1) end)
    |> Enum.map(&select_12_largest_batteries/1)
    |> Enum.map(&mega_joltify/1)
    |> Enum.sum()
  end

  def mega_joltify(rest) do
    mega_joltify_iter(rest, 0)
  end

  defp mega_joltify_iter([], total) do
    total
  end

  defp mega_joltify_iter([next | rest], total) do
    mega_joltify_iter(rest, total * 10 + next)
  end

  def select_12_largest_batteries(elements) do
    select_12_largest_batteries_iter(elements, 12)
  end

  defp select_12_largest_batteries_iter(_elements, 0) do
    []
  end

  defp select_12_largest_batteries_iter(elements, iter) do
    {largest_digit, remaining_batteries} = largest_digit_for_place(elements, iter)

    [largest_digit | select_12_largest_batteries_iter(remaining_batteries, iter - 1)]
  end

  def largest_digit_for_place(searchable, place) do
    {search_set, keep_set} = split_at(searchable, place)

    {largest, index} = find_leftmost_largest(search_set)

    {_, after_largest} = Enum.split(search_set, index + 1)

    {largest, after_largest ++ keep_set}
  end

  def find_leftmost_largest(searchable) do
    find_leftmost_largest_iter(searchable, 0)
  end

  defp find_leftmost_largest_iter([current | []], index) do
    {current, index}
  end

  defp find_leftmost_largest_iter([current | searchable], index) do
    {right_largest, right_index} = find_leftmost_largest_iter(searchable, index + 1)

    case current >= right_largest do
      true -> {current, index}
      false -> {right_largest, right_index}
    end
  end

  def split_at(splittable, decimal_position) do
    {left, right, _} = split_at_iter(splittable, decimal_position)

    {left, right}
  end

  defp split_at_iter([], decimal_position) do
    {[], [], decimal_position - 1}
  end

  defp split_at_iter([next | rest], decimal_position) do
    {left, right, last_decimal_position} = split_at_iter(rest, decimal_position)

    case last_decimal_position <= 0 do
      true -> {[next | left], right, last_decimal_position}
      false -> {left, [next | right], last_decimal_position - 1}
    end
  end

  def run_part_1(lines) do
    lines
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(fn str_nums -> Enum.map(str_nums, &String.to_integer/1) end)
    |> Enum.map(&maximize_joltage/1)
    |> Enum.map(&joltify/1)
    |> Enum.sum()
  end

  def joltify([tens | [ones | []]]) do
    # Logger.debug("Jolted: #{tens * 10 + ones}")
    tens * 10 + ones
  end

  def maximize_joltage(batteries) do
    # Logger.debug("Battery line: #{inspect(batteries)}")
    {tens, tenless_ones} = max_tens(batteries)
    ones = max_ones(tenless_ones)
    # Logger.debug("Post find: #{inspect(tens)} #{inspect(ones)}")
    [tens | [ones | []]]
  end

  def max_tens([_single | []]) do
    0
  end

  def max_tens([tens | [ones | []]]) do
    {tens, [ones]}
  end

  def max_tens([next | rest]) do
    # Logger.debug("Starting with #{inspect(next)} #{inspect(rest)}")
    max_tens_eliding(next, rest, [])
  end

  defp max_tens_eliding(current_max, [last | []], build_up) do
    {current_max, [last | build_up]}
  end

  defp max_tens_eliding(current_max, [next | rest], build_up) do
    # Logger.debug(
    #   "Evaluating #{current_max} vs #{next}, with #{inspect(rest)} remaining and #{inspect(build_up)} built up"
    # )

    case next > current_max do
      true -> max_tens_eliding(next, rest, [])
      false -> max_tens_eliding(current_max, rest, [next | build_up])
    end
  end

  def max_ones([single | []]) do
    single
  end

  def max_ones([next | rest]) do
    max(next, max_ones(rest))
  end
end
