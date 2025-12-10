defmodule Day92Test do
  use ExUnit.Case
  doctest Day92

  setup context do
    case context[:no_agent] do
      true ->
        :ok

      _ ->
        if starting_shape = context[:tile_segment] do
          TileSegments.start_link(starting_shape)
        end

        :ok
    end
  end

  @tag tile_segment: [{0, 0}, {2, 0}, {2, 2}, {0, 2}]
  test "Given some point {1, 1}, when evaluating against the box {0, 0}, {2, 0}, {2, 2}, {0, 2}, then TileSegments.inside will return true" do
    point = {1, 1}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{0, 0}, {2, 0}, {2, 2}, {0, 2}]
  test "Given some point {0, 1}, when evaluating against the box {0, 0}, {2, 0}, {2, 2}, {0, 2}, then TileSegments.inside will return true" do
    point = {0, 1}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{0, 0}, {2, 0}, {2, 2}, {0, 2}]
  test "Given some point {0, 2}, when evaluating against the box {0, 0}, {2, 0}, {2, 2}, {0, 2}, then TileSegments.inside will return true" do
    point = {0, 2}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{0, 0}, {2, 0}, {2, 2}, {0, 2}]
  test "Given some point {0, 3}, when evaluating against the box {0, 0}, {2, 0}, {2, 2}, {0, 2}, then TileSegments.inside will return false" do
    point = {0, 3}

    assert TileSegments.inside?(point) == false
  end

  @tag tile_segment: [{0, 0}, {2, 0}, {2, 2}, {0, 2}]
  test "Given some point {3, 0}, when evaluating against the box {0, 0}, {2, 0}, {2, 2}, {0, 2}, then TileSegments.inside will return false" do
    point = {3, 0}

    assert TileSegments.inside?(point) == false
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {9, 3} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {9, 3}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {2, 5} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {2, 5}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {2, 1{ and the sample puzzle tiles, TileSegments.inside? will return false" do
    point = {2, 1}

    assert TileSegments.inside?(point) == false
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {9, 7} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {9, 7}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {9, 5} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {9, 7}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {11, 3} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {11, 3}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {11, 1} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {11, 1}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {7, 1} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {7, 1}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {6, 1} and the sample puzzle tiles, TileSegments.inside? will return false" do
    point = {6, 1}

    assert TileSegments.inside?(point) == false
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {2, 4} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {2, 4}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {4, 5} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {4, 5}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {4, 6} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {4, 6}

    assert TileSegments.inside?(point) == false
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {10, 6} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {10, 7}

    assert TileSegments.inside?(point) == true
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {10, 8} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {10, 8}

    assert TileSegments.inside?(point) == false
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given point {100, 100} and the sample puzzle tiles, TileSegments.inside? will return true" do
    point = {100, 100}

    assert TileSegments.inside?(point) == false
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given the list of points from the sample, filter_unmakeable will remove all pair combinations for which all four corners are not inside" do
    input = [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]

    assert Day92.filter_unmakeable(input) == [
             {{7, 1}, {11, 1}},
             {{7, 1}, {9, 5}},
             {{7, 1}, {7, 3}},
             {{11, 1}, {11, 7}},
             {{11, 1}, {9, 7}},
             {{11, 1}, {9, 5}},
             {{11, 1}, {7, 3}},
             {{11, 7}, {9, 7}},
             {{11, 7}, {9, 5}},
             {{9, 7}, {9, 5}},
             {{9, 5}, {2, 5}},
             {{9, 5}, {2, 3}},
             {{9, 5}, {7, 3}},
             {{2, 5}, {2, 3}},
             {{2, 5}, {7, 3}},
             {{2, 3}, {7, 3}}
           ]
  end

  test "Given a list of pairs of coordinates, max_area will return the largest area of the squares they create" do
    squares = [
      {{7, 1}, {11, 1}},
      {{7, 1}, {9, 5}},
      {{7, 1}, {7, 3}},
      {{11, 1}, {11, 7}},
      {{11, 1}, {9, 7}},
      {{11, 1}, {9, 5}},
      {{11, 1}, {7, 3}},
      {{11, 7}, {9, 7}},
      {{11, 7}, {9, 5}},
      {{9, 7}, {9, 5}},
      {{9, 5}, {2, 5}},
      {{9, 5}, {2, 3}},
      {{9, 5}, {7, 3}},
      {{2, 5}, {2, 3}},
      {{2, 5}, {7, 3}}
    ]

    assert Day92.max_area(squares) == 24
  end

  test "Given a list of strings representing the input, parse_coords will return a list of tuples " do
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

    assert Day92.parse_coords(lines) == [
             {7, 1},
             {11, 1},
             {11, 7},
             {9, 7},
             {9, 5},
             {2, 5},
             {2, 3},
             {7, 3}
           ]
  end

  @tag tile_segment: [{7, 1}, {11, 1}, {11, 7}, {9, 7}, {9, 5}, {2, 5}, {2, 3}, {7, 3}]
  test "Given the sample input coordinates, run_part_2 will return 24" do
    lines = [
      {7, 1},
      {11, 1},
      {11, 7},
      {9, 7},
      {9, 5},
      {2, 5},
      {2, 3},
      {7, 3}
    ]

    assert Day92.run_part_2(lines) == 24
  end
end
