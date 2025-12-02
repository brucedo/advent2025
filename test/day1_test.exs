defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Given some input in the format L##, where ## is any integer, when presented to decode, then a tuple {:ok, (:L, ##)} will be constructed" do
    line = "L25"

    assert Day1.decode(line) == {:ok, {:L, 25}}
  end

  test "Given some input in the format R##, where ## is any integer, when presented to decode, then a tuple {:ok, (:R, ##)} will be constructed" do
    line = "R232"

    assert Day1.decode(line) == {:ok, {:R, 232}}
  end

  test "Given some input in the format Ly, where y is any non-numeric value, then a tuple {:error, 'Must be in the form R|L[0-9]+'} will be constructed" do
    line = "L674b"

    assert Day1.decode(line) == {:error, "Must be in the form R|L[0-9]+"}
  end

  test "Given some input in the format Ry, where y is any non-numeric value, then a tuple {:error, 'Must be in the form R|L[0-9]+'} will be constructed" do
    line = "Ry5644"

    assert Day1.decode(line) == {:error, "Must be in the form R|L[0-9]+"}
  end

  test "Given some input in the format k##, where k is any character other than L or R, then a tuple {:error, 'Must be in the form R|L[0-9]+'} will be constructed" do
    line = "J4443"

    assert Day1.decode(line) == {:error, "Must be in the form R|L[0-9]+"}
  end

  test "Given some number n and a tuple {:ok, {:L, ##}}, when presented to dial(), then dial will return n - ## modulo 100" do
    start = 50
    change = {:ok, {:L, 68}}

    assert Day1.dial(start, change) == 82
  end

  test "Given some number n and a tuple {:ok, {:R, ##}}, when presented to dial(), then dial will return n + ## modulo 100" do
    start = 52
    change = {:ok, {:R, 48}}

    assert Day1.dial(start, change) == 0
  end

  test "Given some number n and a tuple {:error, _}, when presented to dial(), then dial will return {:error, _}" do
    start = 34
    change = {:error, "Must be in the form of R|L[0-9]+"}

    assert {:error, _} = Day1.dial(start, change)
  end

  test "Given some number 0 <= n < 100, when presented to adjust() then adjust will return {n, 0}" do
    start = 0..99

    adjusted =
      for n <- start do
        Day1.adjust(n)
      end

    assert Enum.all?(adjusted, fn {n, count} -> n <= 99 && n >= 0 && count == 0 end)
  end

  test "Given some number n >= 100, when presented to adjust(), then adjust will return {n % 100, n / 100}" do
    start = 100..1000

    adjusted =
      for n <- start do
        Day1.adjust(n)
      end

    assert Enum.all?(Enum.zip(start, adjusted), fn {original, {modulod, divided}} ->
             modulod == Integer.mod(original, 100) && divided == Integer.floor_div(original, 100)
           end)
  end

  test "Given the sequence of inputs from the example, run_part_1 should return 3" do
    inputs = [
      "L68",
      "L30",
      "R48",
      "L5",
      "R60",
      "L55",
      "L1",
      "L99",
      "R14",
      "L82"
    ]

    assert Day1.run_part_1(inputs) == 3
  end

  test "Given the sequence of inputs from the example, run_part_2 should return 6" do
    inputs = [
      "L68",
      "L30",
      "R48",
      "L5",
      "R60",
      "L55",
      "L1",
      "L99",
      "R14",
      "L82"
    ]

    assert Day1.run_part_2(inputs) == 6
  end
end
