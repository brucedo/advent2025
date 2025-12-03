defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "Given some number nn, when presented to doubled?, then true is returned" do
    nn = 1_188_511_885
    length = Integer.to_string(nn) |> String.length()

    assert Day2.doubled?(nn, length)
  end

  test "Given some number nm, when presented to doubled?, then false is returned" do
    nm = 11_885_411_885
    length = Integer.to_string(nm) |> String.length()

    assert !Day2.doubled?(nm, length)
  end

  test "Given some input in the form [0-9]+-[0-9]+, when presented to numberfy_range, then a numeric range [0-9]+ to [0-9]+ is returned" do
    range = "1188511880-1188511890"

    assert Day2.numberfy_range(range) == 1_188_511_880..1_188_511_890
  end

  test "Given the sample puzzle input, when presented to run_part_1, then 1227775554 should be the result" do
    input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert Day2.run_part_1([input]) == 1_227_775_554
  end

  test "Given some value nm, when presented to repeats(), then false is returned" do
    input = 222_220

    assert !Day2.repeats?(input)
  end

  test "Given some value nn, when presented to repeats(), then true is returned" do
    input = 99

    assert Day2.repeats?(input)
  end

  test "Given some value nnn, when presented to repeats(), then true is returned" do
    input = 123_123_123

    assert Day2.repeats?(input)
  end

  test "Given some value nnnnnnnnnn, when presented to repeats(), then true is returned" do
    input = 21_212_121_212_121_212_121

    assert Day2.repeats?(input)
  end

  test "Given size 1, when presented to find_divisible_slice_sizes, an empty list should be returned" do
    assert Day2.find_divisible_slice_sizes(1) == []
  end

  test "Given size 2, when presented to find_divisible_slice_sizes, [1] should be returned" do
    assert Day2.find_divisible_slice_sizes(2) == [1]
  end

  test "Given size 3, when presented to find_divisible_slice_sizes, [1] should be returned" do
    assert Day2.find_divisible_slice_sizes(3) == [1]
  end

  test "Given size 4, when presented to find_divisible_slice_sizes, [1, 2] should be returned" do
    assert Day2.find_divisible_slice_sizes(4) == [1, 2]
  end

  test "Given size 10, when presented to find_divisible_slice_sizes, [1, 2, 5] should be returned" do
    assert Day2.find_divisible_slice_sizes(10) == [1, 2, 5]
  end

  test "Given size 100, when presented to find_divisible_slice_sizes, [1, 2, 4, 5, 10, 20, 25, 50]" do
    assert Day2.find_divisible_slice_sizes(100) == [1, 2, 4, 5, 10, 20, 25, 50]
  end

  test "Given a slice of 9, slice_size of 1, a string representation of 99 and a string width of 2, when presented to does_repeat?, then true is returned " do
    assert Day2.does_repeat?("9", 1, "99", 2)
  end

  test "Given a slice of 123, slice size of 2, a string representation of 123123123, and a string width of 9, when presented to does_repeat?, then true is returned" do
    assert Day2.does_repeat?("123", 3, "123123123", 9)
  end

  test "Given a slice of size 212, size 3, a string representation of 21212121212121212121, and a string width of 20, when presented to does_repeat, then false is returned" do
    assert !Day2.does_repeat?("212", 3, "21212121212121212121", 20)
  end

  test "Given a divisor list of [1], the string 99, and string width 2, when presented to repeat_test, true is returned" do
    assert Day2.repeat_test([1], "99", 2)
  end

  test "Given the sample puzzle input, when presented to run_part_2, then 4174379265 should be returned" do
    input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert Day2.run_part_2([input]) == 4_174_379_265
  end
end
