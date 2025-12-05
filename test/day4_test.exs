defmodule Day4Test do
  require Logger
  use ExUnit.Case
  doctest(Day4)

  test "Given some grid coordinate (0, 0) and a 2x2 grid, find_neighbors will return the points (0,1), (1, 1), (1, 0)" do
    sampled_coord = %Point{x: 0, y: 0}

    grid = %Grid{height: 2, width: 2}

    neighbors = Day4.find_neighbors(sampled_coord, grid)

    assert length(neighbors) == 3
    assert Enum.member?(neighbors, %Point{x: 1, y: 0})
    assert Enum.member?(neighbors, %Point{x: 1, y: 1})
    assert Enum.member?(neighbors, %Point{x: 0, y: 1})
  end

  test "Given some grid coordinate (0, 0) and a 1x1 grid, find_neighbors will return an empty list" do
    sampled_coord = %Point{x: 0, y: 0}

    grid = %Grid{height: 1, width: 1}

    assert Day4.find_neighbors(sampled_coord, grid) == []
  end

  test "Given some grid coordiantes (1, 1) and a 2x2 grid, find_neighbors will return (0, 1), (0, 0), (1, 0)" do
    sampled_coord = %Point{x: 1, y: 1}

    grid = %Grid{height: 2, width: 2}

    neighbors = Day4.find_neighbors(sampled_coord, grid)

    assert length(neighbors) == 3
    assert Enum.member?(neighbors, %Point{x: 1, y: 0})
    assert Enum.member?(neighbors, %Point{x: 0, y: 0})
    assert Enum.member?(neighbors, %Point{x: 0, y: 1})
  end

  test "Given some grid coordinates (1, 1) and a 3x3 grid, find_neighbors will return all eight neighboring coordinates" do
    sampled_coord = %Point{x: 1, y: 1}

    grid = %Grid{height: 3, width: 3}

    neighbors = Day4.find_neighbors(sampled_coord, grid)

    assert length(neighbors) == 8
    assert Enum.member?(neighbors, %Point{x: 0, y: 0})
    assert Enum.member?(neighbors, %Point{x: 0, y: 1})
    assert Enum.member?(neighbors, %Point{x: 0, y: 2})
    assert Enum.member?(neighbors, %Point{x: 1, y: 0})
    assert Enum.member?(neighbors, %Point{x: 1, y: 2})
    assert Enum.member?(neighbors, %Point{x: 2, y: 0})
    assert Enum.member?(neighbors, %Point{x: 2, y: 1})
    assert Enum.member?(neighbors, %Point{x: 2, y: 2})
  end

  test "Given some grid coordinate and a point, add_neighbor will increment the value of the grid coordinate." do
    grid = %Grid{height: 3, width: 3}

    pre_filled = %{
      %Point{x: 0, y: 0} => 0,
      %Point{x: 0, y: 1} => 1,
      %Point{x: 0, y: 2} => 2,
      %Point{x: 1, y: 0} => 3,
      %Point{x: 1, y: 1} => 4,
      %Point{x: 1, y: 2} => 5,
      %Point{x: 2, y: 0} => 6,
      %Point{x: 2, y: 1} => 7,
      %Point{x: 2, y: 2} => 8
    }

    grid = %{grid | map: pre_filled}

    updated_grid = Day4.add_neighbor(grid, %Point{x: 1, y: 2})

    assert Map.get(updated_grid.map, %Point{x: 1, y: 2}) == 6
  end

  test "Given some text input for a row, walk_row will return the full list of neighboring Points that must be incremented" do
    row = "@@@@@.@.@@"

    grid = %Grid{width: 10, height: 10, map: Day4.initialize_map(10, 10)}

    neighbors = Day4.walk_row(row, 3, grid)

    Logger.debug("#{inspect(neighbors)}")

    assert Enum.count(neighbors, fn point -> point == %Point{x: 0, y: 2} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 1, y: 2} end) == 3
    assert Enum.count(neighbors, fn point -> point == %Point{x: 2, y: 2} end) == 3
    assert Enum.count(neighbors, fn point -> point == %Point{x: 3, y: 2} end) == 3
    assert Enum.count(neighbors, fn point -> point == %Point{x: 4, y: 2} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 5, y: 2} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 6, y: 2} end) == 1
    assert Enum.count(neighbors, fn point -> point == %Point{x: 7, y: 2} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 8, y: 2} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 9, y: 2} end) == 2

    assert Enum.count(neighbors, fn point -> point == %Point{x: 0, y: 3} end) == 1
    assert Enum.count(neighbors, fn point -> point == %Point{x: 1, y: 3} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 2, y: 3} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 3, y: 3} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 4, y: 3} end) == 1
    assert Enum.count(neighbors, fn point -> point == %Point{x: 5, y: 3} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 6, y: 3} end) == 0
    assert Enum.count(neighbors, fn point -> point == %Point{x: 7, y: 3} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 8, y: 3} end) == 1
    assert Enum.count(neighbors, fn point -> point == %Point{x: 9, y: 3} end) == 1

    assert Enum.count(neighbors, fn point -> point == %Point{x: 0, y: 4} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 1, y: 4} end) == 3
    assert Enum.count(neighbors, fn point -> point == %Point{x: 2, y: 4} end) == 3
    assert Enum.count(neighbors, fn point -> point == %Point{x: 3, y: 4} end) == 3
    assert Enum.count(neighbors, fn point -> point == %Point{x: 4, y: 4} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 5, y: 4} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 6, y: 4} end) == 1
    assert Enum.count(neighbors, fn point -> point == %Point{x: 7, y: 4} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 8, y: 4} end) == 2
    assert Enum.count(neighbors, fn point -> point == %Point{x: 9, y: 4} end) == 2
  end

  test "Given the sample puzzle input, run_part_1 will return 13" do
    lines = [
      "..@@.@@@@.",
      "@@@.@.@.@@",
      "@@@@@.@.@@",
      "@.@@@@..@.",
      "@@.@@@@.@@",
      ".@@@@@@@.@",
      ".@.@.@.@@@",
      "@.@@@.@@@@",
      ".@@@@@@@@.",
      "@.@.@@@.@."
    ]

    assert Day4.run_part_1(lines) == 13
  end

  test "Given the sample puzzle input, run_part_1 will return 43" do
    lines = [
      "..@@.@@@@.",
      "@@@.@.@.@@",
      "@@@@@.@.@@",
      "@.@@@@..@.",
      "@@.@@@@.@@",
      ".@@@@@@@.@",
      ".@.@.@.@@@",
      "@.@@@.@@@@",
      ".@@@@@@@@.",
      "@.@.@@@.@."
    ]

    assert Day4.run_part_2(lines) == 43
  end
end
