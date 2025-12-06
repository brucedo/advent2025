defmodule Day6 do
  require Logger

  def run_problems() do
    IO.puts("Starting Day 6, part 1")

    lines =
      Common.open(File.cwd(), "day6")
      |> Common.read_raw_pipe()
      |> Common.close()

    part_1_answer = run_part_1(lines)

    IO.puts("The answer to part 1 is #{inspect(part_1_answer)}")

    part_2_answer = run_part_2(lines)

    IO.puts("The answer to part 2 is #{part_2_answer}")
  end

  def run_part_2(lines) do
    {operand_str, operator_str} = split_operands_from_operators(lines)

    Logger.debug("Operand string: #{inspect(operand_str)}")
    Logger.debug("Operator string: #{inspect(operator_str)}")

    operands =
      transpose_str(operand_str)
      |> group_calculations()
      |> Enum.map(&numberify/1)

    operators = functionify(operator_str)

    Logger.debug("Operands: #{inspect(operands)}")
    Logger.debug("Operators: #{inspect(operators)}")

    Logger.debug(
      "Operands length: #{inspect(length(operands))}, operator length: #{inspect(length(operators))}"
    )

    computed = pairwise_compute(operands, operators)

    Logger.debug("Computed results: #{inspect(computed)}")

    Enum.sum(computed)
  end

  def group_calculations(digits) do
    Logger.debug("Digits: #{inspect(digits)}")

    Enum.chunk_while(
      digits,
      "",
      fn number_str, acc ->
        case String.trim(number_str) do
          "" -> {:cont, acc, ""}
          number_str -> {:cont, acc <> " " <> String.trim(number_str)}
        end
      end,
      fn acc ->
        {:cont, acc, ""}
      end
    )
  end

  def transpose_str([first_row | rest]) do
    growing_set = String.codepoints(first_row)

    transpose_str_iter(rest, growing_set)
  end

  defp transpose_str_iter([], growing_set) do
    growing_set
  end

  defp transpose_str_iter([next_row | rest], growing_set) do
    updated_growing_set = merge_str_pairs(String.codepoints(next_row), growing_set)

    transpose_str_iter(rest, updated_growing_set)
  end

  defp merge_str_pairs([], []) do
    []
  end

  defp merge_str_pairs([new_char | remaining_chars], [growing_char | remaining_grow_chars]) do
    Logger.debug("Merging #{inspect(new_char)} onto #{growing_char}")
    [growing_char <> new_char | merge_str_pairs(remaining_chars, remaining_grow_chars)]
  end

  def run_part_1(lines) do
    {operand_str, operator_str} = split_operands_from_operators(lines)

    Logger.debug("Operand string: #{inspect(operand_str)}")
    Logger.debug("Operator string: #{inspect(operator_str)}")

    operands =
      Enum.map(operand_str, &numberify/1)
      |> transpose()

    operators = functionify(operator_str)

    Logger.debug("Operands: #{inspect(operands)}")
    Logger.debug("Operators: #{inspect(operators)}")

    Logger.debug(
      "Operands length: #{inspect(length(operands))}, operator length: #{inspect(length(operators))}"
    )

    computed = pairwise_compute(operands, operators)

    Logger.debug("Computed results: #{inspect(computed)}")

    Enum.sum(computed)
  end

  defp pairwise_compute([], []) do
    []
  end

  defp pairwise_compute([operands | rest_operands], [operator | rest_operator]) do
    [compute(operands, operator) | pairwise_compute(rest_operands, rest_operator)]
  end

  defp split_operands_from_operators([last_operands | [operators | []]]) do
    {[last_operands], operators}
  end

  defp split_operands_from_operators([operand | remaining]) do
    {operands, operators} = split_operands_from_operators(remaining)

    {[operand | operands], operators}
  end

  def compute([], _operator) do
    0
  end

  def compute(operands, operator) do
    Enum.reduce(operands, operator)
  end

  def transpose(operands) do
    Enum.zip(operands)
    |> Enum.map(&Tuple.to_list/1)
  end

  def numberify(line) do
    String.split(line)
    |> Enum.map(&String.to_integer/1)
  end

  def functionify(line) do
    String.split(line) |> Enum.map(&differentiator/1)
  end

  defp differentiator("+") do
    &+/2
  end

  defp differentiator("-") do
    &-/2
  end

  defp differentiator("/") do
    &//2
  end

  defp differentiator("*") do
    &*/2
  end
end
