defmodule Day5 do
  require Logger

  def run_problem() do
    IO.puts("Starting Day 5, part 1")

    lines =
      Common.open(File.cwd(), "day5")
      |> Common.read_file_pipe()
      |> Common.close()

    part_1_answer = run_part_1(lines)

    IO.puts("Part 1 answer is #{part_1_answer}")

    {fresh_id_str, _} = split_input(lines)

    fresh_ids = freshify(fresh_id_str)

    part_2_answer = run_part_2(fresh_ids)

    IO.puts("Part 2 answer is #{part_2_answer}")
  end

  def run_part_2(fresh_bit) do
    merged_ranges =
      Enum.reduce(fresh_bit, [], fn fresh_range, acc -> merge_range(fresh_range, acc) end)

    range_sizes = Enum.map(merged_ranges, fn [minor | [major | []]] -> major - minor + 1 end)

    Enum.sum(range_sizes)
  end

  def merge_range(new_pair, []) do
    [new_pair]
  end

  def merge_range(new_pair, [only_range | rest]) do
    case merge_pairs(new_pair, only_range) do
      :left_smaller -> [new_pair | [only_range | rest]]
      :right_smaller -> [only_range | merge_range(new_pair, rest)]
      merged_pair -> merge_range(merged_pair, rest)
    end
  end

  def merge_pairs([left_minor | [left_major | []]], [right_minor | [right_major | []]]) do
    combinations =
      {
        left_minor < right_minor && left_major < right_minor,
        left_minor < right_minor && left_major >= right_minor && left_major < right_major,
        left_minor < right_minor && left_major >= right_major,
        left_minor < right_major && left_major < right_major,
        left_minor < right_major && left_major >= right_major,
        left_minor == right_major,
        left_minor > right_major
      }

    case combinations do
      {true, _, _, _, _, _, _} ->
        # [[left_minor, left_major], [right_minor, right_major]]
        :left_smaller

      {false, true, _, _, _, _, _} ->
        [left_minor, right_major]

      {false, false, true, _, _, _, _} ->
        [left_minor, left_major]

      {false, false, false, true, _, _, _} ->
        [right_minor, right_major]

      {false, false, false, false, true, _, _} ->
        [right_minor, left_major]

      {false, false, false, false, false, true, _} ->
        [right_minor, left_major]

      {false, false, false, false, false, false, true} ->
        # [[right_minor, right_major], [left_minor, left_major]]
        :right_smaller
    end
  end

  def run_part_1(lines) do
    {fresh_id_str, food_id_str} = split_input(lines)

    fresh_ids = freshify(fresh_id_str)

    food_ids =
      for food_str <- food_id_str do
        String.to_integer(food_str)
      end

    # Logger.debug("Fresh ids: #{inspect(fresh_ids)}")
    # Logger.debug("Food ids: #{inspect(food_ids)}")

    fresh_list =
      for id <- food_ids do
        is_fresh(id, fresh_ids)
      end

    Enum.filter(fresh_list, fn fresh -> fresh end) |> Enum.count()
  end

  def is_fresh(_id, []) do
    false
  end

  def is_fresh(id, [[lower | [higher | []]] | rest]) do
    case lower <= id && id <= higher do
      false -> is_fresh(id, rest)
      a -> a
    end
  end

  def split_input([]) do
    {[], []}
  end

  def split_input(lines) do
    split_lines =
      lines
      |> Enum.chunk_while(
        [],
        fn next, acc ->
          case next == "" do
            true -> {:cont, acc, []}
            false -> {:cont, [next | acc]}
          end
        end,
        fn acc -> {:cont, acc, []} end
      )

    case split_lines do
      [fresh | [foods | []]] -> {Enum.reverse(fresh), Enum.reverse(foods)}
      [fresh | []] -> {Enum.reverse(fresh), []}
      [[] | [foods | []]] -> {[], Enum.reverse(foods)}
    end
  end

  def freshify(fresh_section) do
    for string_pair <- fresh_section do
      Integer.parse(string_pair)
      |> Kernel.then(fn {first, second_str} ->
        [first | [String.trim_leading(second_str, "-") |> String.to_integer()]]
      end)
    end
  end
end
