defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "Given a column x such that a splitter exists at (x, y+1) and line depicting that splitter, 
    resolve_intersections will return [x] " do
    input = [8]
    subsequent_line = [8]

    assert Day7.resolve_intersections(input, subsequent_line) == [8]
  end

  test "Given a column [x] such that a splitter exists at (x+1, y+1), and a line depicting that splitter, 
    resolve_intersections will return []" do
    input = [8]
    subsequent_line = [9]

    assert Day7.resolve_intersections(input, subsequent_line) == []
  end

  test "Given a column [x] such that a splitter exists at (x+1, y+1) and (x-1, y+1), and a line depicting that splitter, 
    resolve_intersections will return []" do
    input = [7]
    subsequent_line = [6, 8]

    assert Day7.resolve_intersections(input, subsequent_line) == []
  end

  test "Given columns [(x, x+2] such that a splitter exists at (x+2, y+1) and a line depicting that splitter, 
    resolve_interesections will return [x+2]" do
    input = [8, 10]
    subsequent_line = [10]

    assert Day7.resolve_intersections(input, subsequent_line) == [10]
  end

  test "Given columns [(x-1, x+1] such that a splitter exists at (x-1, y+1) and another at (x+1, y+1) and a line depicting that splitter, 
    resolve_intersections will return [x-1, x+1]" do
    input = [8, 10]
    subsequent_line = [8, 10]

    assert Day7.resolve_intersections(input, subsequent_line) == [8, 10]
  end

  test "Given column [x] calculate_new_beams will return columns [x-1, x+1]" do
    input = [9]

    assert Day7.calculate_new_beams(input) == [8, 10]
  end

  test "Given columns [x, x+4] calculate_new_beams will return columns [x-1, x+1, x+3, x+5]" do
    input = [8, 12]

    assert Day7.calculate_new_beams(input) == [7, 9, 11, 13]
  end

  test "Gven columns [x, x+2] calculate_new_beams will return columns [x-1, x+1, x+3]" do
    input = [8, 10]

    assert Day7.calculate_new_beams(input) == [7, 9, 11]
  end

  test "Given column [x] such that a splitter exists at (x, y+1) and a line depicting that splitter, 
    filter_beams will return []" do
    input = [8]
    subsequent_line = [8]

    assert Day7.filter_beams(input, subsequent_line) == []
  end

  test "Given a column [x] such that a splitter exists at (x+1, y+1), and a line depicting that splitter, 
    filter_beams will return [x]" do
    input = [8]
    subsequent_line = [9]

    assert Day7.filter_beams(input, subsequent_line) == [8]
  end

  test "Given a column [x] such that a splitter exists at (x+1, y+1) and (x-1, y+1), and a line depicting that splitter, 
    filter_beams will return [x]" do
    input = [7]
    subsequent_line = [6, 8]

    assert Day7.filter_beams(input, subsequent_line) == [7]
  end

  test "Given columns [(x, x+2] such that a splitter exists at (x+2, y+1) and a line depicting that splitter, 
    filter_beams will return [x+2]" do
    input = [8, 10]
    subsequent_line = [10]

    assert Day7.filter_beams(input, subsequent_line) == [8]
  end

  test "Given columns [(x-1, x+1] such that a splitter exists at (x-1, y+1) and another at (x+1, y+1) and a line depicting that splitter, 
    filter_beams will return []" do
    input = [8, 10]
    subsequent_line = [8, 10]

    assert Day7.filter_beams(input, subsequent_line) == []
  end

  test "Given the sample input, run_part_1 will return 21" do
    input = [
      ".......S.......",
      "...............",
      ".......^.......",
      "...............",
      "......^.^......",
      "...............",
      ".....^.^.^.....",
      "...............",
      "....^.^...^....",
      "...............",
      "...^.^...^.^...",
      "...............",
      "..^...^.....^..",
      "...............",
      ".^.^.^.^.^...^.",
      "..............."
    ]

    assert Day7.run_part_1(input) == 21
  end

  test "Given some list of tuples {index, value_j}, then sum_indexed_values will return a single tuple {index, sum(value_j)}" do
    input = [{1, 4}, {1, 8}, {1, 4}]

    assert Day7.sum_indexed_values(input) == {1, 16}
  end

  # test "Given some list of [{0, 4}], rebuild_count will return a list of [4]" do
  #   input = [{0, 4}]
  #
  #   assert Day7.rebuild_count(input) == [4]
  # end
  #
  # test "Given some list of [{0, 5}, {1, 12}], rebuild_count will return a list of [5, 12]" do
  #   input = [{0, 5}, {1, 12}]
  #
  #   assert Day7.rebuild_count(input) == [5, 12]
  # end
  #
  # test "Given some list of [{0, 4}, {6, 2}, rebuild_count will return a list of [4, 0, 0, 0, 0, 0, 2]" do
  #   input = [{0, 4}, {6, 2}]
  #
  #   assert Day7.rebuild_count(input) == [4, 0, 0, 0, 0, 0, 2]
  # end

  test "Given some puzzle input line ....^.... and a number_list [0, 0, 0, 0, 1, 0, 0, 0, 0] divide_timelines will produce [a big thing]" do
    puzzle_line = "....^...."
    number_list = [0, 0, 0, 0, 1, 0, 0, 0, 0]

    assert Day7.divide_timelines(puzzle_line, number_list) == [
             {0, 0},
             {1, 0},
             {2, 0},
             {3, 0},
             {3, 1},
             {4, 0},
             {5, 1},
             {5, 0},
             {6, 0},
             {7, 0},
             {8, 0}
           ]
  end

  test "Given some puzzle input line ....^.... and a number list [0, 0, 0, 1, 0, 1, 0, 0, 0] divide_timelines will produce [...]" do
    puzzle_line = "....^...."
    number_list = [0, 0, 0, 1, 0, 1, 0, 0, 0]

    assert Day7.divide_timelines(puzzle_line, number_list) == [
             {0, 0},
             {1, 0},
             {2, 0},
             {3, 1},
             {3, 0},
             {4, 0},
             {5, 0},
             {5, 1},
             {6, 0},
             {7, 0},
             {8, 0}
           ]
  end

  test "Given some puzzle input line ....^.... and a number list [5, 4, 3, 0, 1, 0, 6, 8, 10] divide_timelines will produce 
    [{0, 5}, {1, 4}, {2, 3}, {3, 0}, {3, 1}, {4, 0}, {5, 1}, {5, 0}, {6, 6}, {7, 8}, {9, 10}]" do
    puzzle_line = "....^...."
    number_list = [5, 4, 3, 0, 1, 0, 6, 8, 10]

    assert Day7.divide_timelines(puzzle_line, number_list) == [
             {0, 5},
             {1, 4},
             {2, 3},
             {3, 0},
             {3, 1},
             {4, 0},
             {5, 1},
             {5, 0},
             {6, 6},
             {7, 8},
             {8, 10}
           ]
  end

  test "Given [{0, 5}, {0, 4}, {1, 4}, {3, 0}, {3, 1}] group_indices will return [[{0, 5}, {0, 4}], [{1, 4}], [{3, 0}, {3, 1}]" do
    input = [{0, 5}, {0, 4}, {1, 4}, {3, 0}, {3, 1}]

    assert Day7.group_indices(input) == [[{0, 5}, {0, 4}], [{1, 4}], [{3, 0}, {3, 1}]]
  end

  test "Given the sample line ..^...^.....^.. and number line [0, 0, 1, 0, 5, 0, 4, 3, 4, 0, 1, 0, 1, 0, 0], evaluate_future will 
    return [0, 1, 0, 1, 5, 4, 0, 7, 4, 0, 1, 1, 0, 1, 0]" do
    puzzle_input = "..^...^.....^.."
    number_line = [0, 0, 1, 0, 5, 0, 4, 3, 4, 0, 1, 0, 1, 0, 0]

    assert Day7.evaluate_future(puzzle_input, number_line) == [
             0,
             1,
             0,
             1,
             5,
             4,
             0,
             7,
             4,
             0,
             1,
             1,
             0,
             1,
             0
           ]
  end

  test "Given the sample puzzle, run_part_2 will return 40" do
    input = [
      ".......S.......",
      "...............",
      ".......^.......",
      "...............",
      "......^.^......",
      "...............",
      ".....^.^.^.....",
      "...............",
      "....^.^...^....",
      "...............",
      "...^.^...^.^...",
      "...............",
      "..^...^.....^..",
      "...............",
      ".^.^.^.^.^...^.",
      "..............."
    ]

    assert Day7.run_part_2(input) == 40
  end
end
