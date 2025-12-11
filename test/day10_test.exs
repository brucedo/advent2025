defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  setup context do
    case context[:agent] do
      false ->
        :ok

      _ ->
        if visited = context[:visited] do
          Visited.start_link(visited)
        else
          Visited.start_link()
        end

        :ok
    end
  end

  @tag visited: [[true, true, false, false], [true, false, true, false]]
  test "Given the list [true, false, false, false], Visited will return false" do
    input = [true, false, false, false]

    assert Visited.visited?(input) == false
  end

  @tag visited: [[true, true, false, false], [true, false, true, false]]
  test "Given the list [true, false, true, false], Visited will return true" do
    input = [true, false, true, false]

    assert Visited.visited?(input) == true
  end

  @tag visited: [[true, true, false, false], [true, false, true, false]]
  test "Given the list [true, true, false, true], Visited.vist will mark that pattern as visited." do
    pattern = [true, true, false, true]

    Visited.visit(pattern)

    assert Visited.visited?(pattern) == true
  end

  @tag light_map: {2, [[1], [0, 1]]}
  test "Given some list [false, false], LightMap.toggles will return [false, true] and [true, true]" do
    input = [false, false]

    assert LightMap.toggles(input) == [[false, true], [true, true]]
  end

  test "Given some number 1, LightMap.permute_lights will return [[false], [true]]" do
    input = 1

    assert LightMap.permute_lights(input) == [[false], [true]]
  end

  test "Given some number 2, Lightmap.permute_lights will return [[false, false], [false, true], [true, false], [true, true]]" do
    input = 2

    assert LightMap.permute_lights(input) == [
             [false, false],
             [false, true],
             [true, false],
             [true, true]
           ]
  end

  test "Given some toggles (0) and a permutation [false], toggle will return [{[0], [true]}] " do
    toggles = [[0]]
    permutation = [false]

    assert LightMap.toggle(toggles, permutation) == {0, [true]}
  end

  test "Given some toggles (0) and (0, 1) and a permutation [false, true], toggle will return [{[0], [true, true]}, {[0, 1], [true, false]}]" do
    toggles = [[0], [0, 1]]
    permutation = [false, true]

    assert LightMap.toggle(toggles, permutation) == [{[0], [true, true]}, {[0, 1], [true, false]}]
  end

  @tag visited: [[false, false], [true, false]]
  test "Given a list of [false, true], [true, false], and [true, true], filter_by_visited will return [false, true] and [true, true]" do
    input = [[false, true], [true, false], [true, true]]

    assert Day10.filter_by_visited(input) == [[false, true], [true, true]]
  end
end
