defmodule Day9Test do
  use ExUnit.Case

  test "Given some pair of points {1, 2} and {3, 4}, area() will return 9" do
    left = {1, 2}
    right = {3, 4}

    assert Day9.area(left, right) == 9
  end

  test "Given some pair of points {4, 5} and {1, 2} area() will return 16" do
    left = {4, 5}
    right = {1, 2}

    assert Day9.area(left, right) == 16
  end

  test "Given some pair of points {4, 4} and {4, 8} area() will return 5" do
    left = {4, 4}
    right = {4, 8}

    assert Day9.area(left, right) == 5
  end

  test "Given some pair of points {4, 4} and {9, 4} area() will return 6" do
    left = {4, 4}
    right = {9, 4}

    assert Day9.area(left, right) == 6
  end

  test "Given some pair of points {4, 4} and {4, 4} area() will return 1" do
    left = {4, 4}
    right = {4, 4}

    assert Day9.area(left, right) == 1
  end

  test "Given some constant point {0, 0} and a list of points [4, 4], max_area() will return 25 " do
    constant = {0, 0}
    others = [{4, 4}]

    assert Day9.max_area(constant, others) == 25
  end

  test "Given some constant point {0, 0} and a list of points [{4, 4}, {3, 3}, {6, 6}], max_area will return 49" do
    constant = {0, 0}
    others = [{4, 4}, {3, 3}, {6, 6}]

    assert Day9.max_area(constant, others) == 49
  end

  test "Given a text line '1,3' then form_point will return {1, 3}" do
    line = "1,3"

    assert Day9.form_point(line) == {1, 3}
  end

  test "Given the sample input, run_part_1 will return 50" do
    lines = [
      "7,1 ",
      "11,1",
      "11,7",
      "9,7 ",
      "9,5 ",
      "2,5 ",
      "2,3 ",
      "7,3 "
    ]

    assert Day9.run_part_1(lines) == 50
  end
end
