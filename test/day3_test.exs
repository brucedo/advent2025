defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Given some single element list, max_tens will return 0" do
    single_battery = [9]

    assert Day3.max_tens(single_battery) == 0
  end

  test "Given some pair of elements in a list, max_tens will return the first" do
    pair = [3, 9]

    assert Day3.max_tens(pair) == {3, [9]}
  end

  test "Given some list of elements of range 0..n, max_tens will return the largest of the set 0..n-1" do
    elements = [6, 3, 5, 7, 2, 4, 8, 9]

    assert Day3.max_tens(elements) == {8, [9]}
  end

  test "Given some list of elements of range 0..n, max_tens will return only those elements to the right of the largest as the second tuple element" do
    elements = [6, 3, 5, 7, 2, 4, 8, 9]

    assert Day3.max_tens(elements) == {8, [9]}
  end

  test "Given some single element list, max_ones will return that element" do
    single_battery = [9]

    assert Day3.max_ones(single_battery) == 9
  end

  test "Given some pair of elements in a list, max_ones will return the largest" do
    pair = [3, 9]

    assert Day3.max_ones(pair) == 9
  end

  test "Given some list of elements of range 0..n, max_ones will return the largest of the set 0..n" do
    elements = [6, 3, 5, 7, 2, 4, 8, 9]

    assert Day3.max_ones(elements) == 9
  end

  test "Given some list of elements of range 0..n where element[0] is the largest, max_ones will return the largest of the set 0..n" do
    elements = [9, 3, 6, 5, 7, 2, 4, 8]

    assert Day3.max_ones(elements) == 9
  end

  test "Given some list of battery 'joltages', maximize_joltage will find the largest pairing of batteries" do
    elements = [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9]

    assert Day3.maximize_joltage(elements) == [8, 9]
  end

  test "Given some pair of elements [a, b], joltify will turn them into a single number ab" do
    assert Day3.joltify([8, 9]) == 89
  end

  test "Given the puzzle sample input, run_part_1 will return 357" do
    rows = [
      "987654321111111",
      "811111111111119",
      "234234234234278",
      "818181911112111"
    ]

    assert Day3.run_part_1(rows) == 357
  end

  test "Given some list of n numbers and a place p, split_at will produce 2 lists of length n - p + 1 and p - 1 respectively" do
    elements = [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9]

    {left, right} = Day3.split_at(elements, 12)

    assert length(left) == 4
    assert length(right) == 11
  end

  test "Given some list of n numbers, find_leftmost_largest will return the value and index of the leftmost largest element." do
    elements = "8181" |> String.codepoints() |> Enum.map(&String.to_integer/1)

    assert {8, 0} == Day3.find_leftmost_largest(elements)
  end

  test "Given a large list of n numbers and a decimal place, largest_digit_for_place will find the largest, leftmost digit for the decimal place " do
    elements = [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1]

    {max, _} = Day3.largest_digit_for_place(elements, 12)

    assert max == 8
  end

  test "Given a large list of n numbers and a decimal place, largest_digit_for_place will remove any elements to the left of that place while keeping all elements to the right" do
    elements = [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1]

    {_, remaining} = Day3.largest_digit_for_place(elements, 9)

    assert remaining == [1, 1, 1, 1, 2, 1, 1, 1]
  end

  test "Given one line of the sample input, select_12_largest_batteries will produce an output with the 12 largest batteries lit in order" do
    elements = [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1]

    big_battery = Day3.select_12_largest_batteries(elements)

    assert big_battery == [8, 8, 8, 9, 1, 1, 1, 1, 2, 1, 1, 1]
  end

  test "Given a list of n numbers, mega_joltify will produce a number such that each index i in the list will be 10^i place in the number" do
    elements = [8, 8, 8, 9, 1, 1, 1, 1, 2, 1, 1, 1]

    assert Day3.mega_joltify(elements) == 888_911_112_111
  end

  test "Given the full sample input, run_part_2 will work I guess" do
    rows = [
      "987654321111111",
      "811111111111119",
      "234234234234278",
      "818181911112111"
    ]

    assert Day3.run_part_2(rows) == 3_121_910_778_619
  end
end
