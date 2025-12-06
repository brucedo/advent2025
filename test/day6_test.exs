defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "Given an empty string \"\", numberify will produce []" do
    input = ""

    assert Day6.numberify(input) == []
  end

  test "Given an input String \"nnn\", numberify will produce [nnn] " do
    input = "1234"

    assert Day6.numberify(input) == [1234]
  end

  test "Given an input list \"nnn mmmm\", numberify will produce [nnn, mmmm]" do
    input = "123 4455"

    assert Day6.numberify(input) == [123, 4455]
  end

  test "Given an input list \"nnn                            mmmm\", numberify will produce [nnn, mmmm]" do
    input = "456                            1241"

    assert Day6.numberify(input) == [456, 1241]
  end

  test "Given an input list of \"+\", functionify will produce a function reference to addition in a list" do
    input = "+"

    assert Day6.functionify(input) == [&+/2]
  end

  test "Given an input list of \"-\", functionify will produce a function reference to subtraction in a list" do
    input = "-"

    assert Day6.functionify(input) == [&-/2]
  end

  test "Given an input list of \"*\", functionify will produce a function reference to multiplication in a list" do
    input = "*"

    assert Day6.functionify(input) == [&*/2]
  end

  test "Given an input list of \"/\", functionify will produce a function reference to division in a list" do
    input = "/"

    assert Day6.functionify(input) == [&//2]
  end

  test "Given an input list of \" +                -            *    /\", functionify will produce a reference to 
addition, subtraction, multiplication and division in a list" do
    input = " +                -            *    /"

    assert Day6.functionify(input) == [&+/2, &-/2, &*/2, &//2]
  end

  test "Given some list [[], [], []], transpose will produce a list of []" do
    input = [[], [], []]

    assert Day6.transpose(input) == []
  end

  test "Given some list [[123], [456], [789]], transpose will produce a list [[123, 456, 789]]" do
    input = [[123], [456], [789]]

    assert Day6.transpose(input) == [[123, 456, 789]]
  end

  test "Given some list [[123, 456], [1234, 5678], [12345, 67890]], transpose will produce a list [[123, 1234, 12345], [456, 5678, 67890]]" do
    input = [[123, 456], [1234, 5678], [12345, 67890]]

    assert Day6.transpose(input) == [[123, 1234, 12345], [456, 5678, 67890]]
  end

  test "Given some list [[123, 456, 789], [98, 765, 432], [109, 876, 543]], transpose will produce a list [[123, 98, 109], [456, 765, 876], [789, 432, 543]]" do
    input = [[123, 456, 789], [98, 765, 432], [109, 876, 543]]

    assert Day6.transpose(input) == [[123, 98, 109], [456, 765, 876], [789, 432, 543]]
  end

  test "Given an operator list [] and an operator, compute will produce 0" do
    input = []
    operator = &+/2

    assert Day6.compute(input, operator) == 0
  end

  test "Given an operator list [3, 2] and an operator, compute will produce the application of the operator hd(list) op hd(tl(list))" do
    input = [3, 2]
    operator = &*/2

    assert Day6.compute(input, operator) == 6
  end

  test "Given an operator list [3, 2, 6] and an operator op, compute will produce hd(list) op hd(tl(list) op hd(tl(tl(list))" do
    input = [3, 2, 6]
    operator = &+/2

    assert Day6.compute(input, operator) == 11
  end

  test "Given the sample input, run_part_1 will produce 4277556" do
    input = [
      "123 328  51 64 ",
      " 45 64  387 23 ",
      "  6 98  215 314",
      "*   +   *   +  "
    ]

    assert Day6.run_part_1(input) == 4_277_556
  end

  test "Given a list of strings [\"123\", \" 45\"], transpose_str will produce [\"1 \", \"24\", \"35\"]" do
    input = ["123", " 45"]

    assert Day6.transpose_str(input) == ["1 ", "24", "35"]
  end

  test "Given a list of strings [\"123 328\", \" 45 64 \"], transpose_str will produce [\"1 \", \"24\", \"35\", \"  \", \"36\", \"24\", \"8 \"] " do
    input = [
      "123 328",
      " 45 64 "
    ]

    assert Day6.transpose_str(input) == ["1 ", "24", "35", "  ", "36", "24", "8 "]
  end

  test "Given the sample input, transpose_str will produce the transpose that I can't be arsed to reproduce here because it's long" do
    input = [
      "123 328  51 64 ",
      " 45 64  387 23 ",
      "  6 98  215 314"
    ]

    assert Day6.transpose_str(input) == [
             "1  ",
             "24 ",
             "356",
             "   ",
             "369",
             "248",
             "8  ",
             "   ",
             " 32",
             "581",
             "175",
             "   ",
             "623",
             "431",
             "  4"
           ]
  end

  test "Given a list of numeric strings [\"1 \", \"24\", \"  \", \"36\", \"24\"], then group_calculations will emit [\"1 24, \"36 24\"]" do
    input = [
      "1 ",
      "24",
      "  ",
      "36",
      "24"
    ]

    assert Day6.group_calculations(input) == [" 1 24", " 36 24"]
  end

  test "Given the linearized strings from the sample, group_calculations will emit [\"1 24 356\", \"369 248 8\", \"32 581 175\", \"623 431 4\"]" do
    input = [
      "1  ",
      "24 ",
      "356",
      "   ",
      "369",
      "248",
      "8  ",
      "   ",
      " 32",
      "581",
      "175",
      "   ",
      "623",
      "431",
      "  4"
    ]

    assert Day6.group_calculations(input) == [
             " 1 24 356",
             " 369 248 8",
             " 32 581 175",
             " 623 431 4"
           ]
  end

  test "Given the sample input, run_part_2 will return 3263827" do
    input = [
      "123 328  51 64 ",
      " 45 64  387 23 ",
      "  6 98  215 314",
      "*   +   *   +  "
    ]

    assert Day6.run_part_2(input) == 3_263_827
  end
end
