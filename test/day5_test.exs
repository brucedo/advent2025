defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "Given some set of lines [n] with no blank entry, split_input will return a pair of lists {[n], []}" do
    lines = ["3-5", "4-5", "7-10"]

    assert Day5.split_input(lines) == {["3-5", "4-5", "7-10"], []}
  end

  test "Given some set of lines [n], split input will return a pair of lists [n], []" do
    lines = ["3-5", "4-5", "7-10", ""]

    assert Day5.split_input(lines) == {["3-5", "4-5", "7-10"], []}
  end

  test "Given some set of lines [n], split input will return a pair of lists [], [n]" do
    lines = ["", "3-5", "4-5", "7-10"]

    assert Day5.split_input(lines) == {[], ["3-5", "4-5", "7-10"]}
  end

  test "Given some set of lines [nm], split input will return a pair of lists [n], [m]" do
    lines = ["3-5", "4-5", "7-10", "", "5", "10", "12", "23"]

    assert Day5.split_input(lines) == {["3-5", "4-5", "7-10"], ["5", "10", "12", "23"]}
  end

  test "Given some set of lines [], split input will return a pair of lists [], []" do
    lines = []

    assert Day5.split_input(lines) == {[], []}
  end

  test "Given some set of strings in format 'n-m', freshify will produce a list of lists in the form [[n, m], ...]" do
    lines = ["3-5", "4-5", "7-10"]

    assert Day5.freshify(lines) == [[3, 5], [4, 5], [7, 10]]
  end

  test "Given some set of strings [], freshify will produce an empty list []" do
    lines = []

    assert Day5.freshify(lines) == []
  end

  test "Given the sample puzzle input, run_part_1 will return 3" do
    input = ["3-5", "10-14", "16-20", "12-18", "", "1", "5", "8", "11", "17", "32"]

    assert Day5.run_part_1(input) == 3
  end

  test "Given a pair of fresh endpoints [n, m] and a set of ranges [p_i, q_i] such that 
    n < p_0 and m < p_0, then merge_range will return a set of ranges [[n, m], [p_0, q_0], [p_1, q_1], ... ]" do
    fresh_pair = [3, 5]
    ranges = [[7, 10], [11, 21], [30, 31]]

    assert Day5.merge_range(fresh_pair, ranges) == [[3, 5], [7, 10], [11, 21], [30, 31]]
  end

  test "Given a pair of fresh endpoints [n, m] and a set of ranges [p_i, q_i] such that 
    n < all p_i and m <= some q_j, then merge_range will return a set of ranges [[p_i, q_i], [n, q_j], ...]" do
    fresh_pair = [3, 5]
    ranges = [[4, 6], [8, 12], [14, 16]]

    assert Day5.merge_range(fresh_pair, ranges) == [[3, 6], [8, 12], [14, 16]]
  end

  test "Given a pair of fresh endpoints [n, m] and a set of ranges [p_i, q_i] such that 
    n >= some p_j and m <= some q_j, then merge_range will return the original set of ranges" do
    fresh_pair = [15, 16]
    ranges = [[4, 6], [8, 12], [14, 16]]

    assert Day5.merge_range(fresh_pair, ranges) == [[4, 6], [8, 12], [14, 16]]
  end

  test "Given a pair of fresh endpoints [n, m] and a set of ranges [p_i, q_i] such that 
    n >= some p_j and m <= some q_k, then merge_range will return [[p_i, q_i], [p_j, q_k], ...]" do
    fresh_pair = [11, 15]
    ranges = [[4, 6], [8, 12], [14, 16]]

    assert Day5.merge_range(fresh_pair, ranges) == [[4, 6], [8, 16]]
  end

  test "Given a pair of fresh endpoints [n, m] and a set of ranges [p_i, q_i] such that 
    n <= some q_k and m < all subsequent p_i, then merge_range will return [[p_0, q_0], ..., [p_i, m], ..." do
    fresh_pair = [15, 17]
    ranges = [[4, 6], [8, 12], [14, 16]]

    assert Day5.merge_range(fresh_pair, ranges) == [[4, 6], [8, 12], [14, 17]]
  end

  test "Given a pair of fresh endpoints [n, m] and an empty range [], then merge_range will return [[n, m]]" do
    fresh_pair = [5, 10]
    ranges = []

    assert Day5.merge_range(fresh_pair, ranges) == [[5, 10]]
  end

  test "Given the first part of the sample input, run_part_2 will return 14" do
    input = [[3, 5], [10, 14], [16, 20], [12, 18]]

    assert Day5.run_part_2(input) == 14
  end
end
