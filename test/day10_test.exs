defmodule Day10Test do
  require Logger
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

        if light_map = context[:light_map] do
          LightMap.start_link(light_map)
        else
          LightMap.start_link()
        end

        if jolt_map = context[:jolt_map] do
          JoltMap.start_link(jolt_map)
        else
          JoltMap.start_link()
        end

        :ok
    end
  end

  @tag visited: [0b0011, 0b0101]
  test "Given the list 0b1000, Visited will return false" do
    input = 0b0001

    assert Visited.visited?(input) == false
  end

  @tag visited: [0b0011, 0b0101]
  test "Given the list [true, false, true, false], Visited will return true" do
    input = 0b0101

    assert Visited.visited?(input) == true
  end

  @tag visited: [0b0011, 0b0101]
  test "Given the list [true, true, false, true], Visited.vist will mark that pattern as visited." do
    pattern = 0b1101

    Visited.visit(pattern)

    assert Visited.visited?(pattern) == true
  end

  test "Given some number 1, LightMap.permute_lights will return [10]" do
    input = 0b01

    light_perms = LightMap.permute_lights(input)

    assert Enum.member?(light_perms, 1)
    assert Enum.member?(light_perms, 0)
  end

  test "Given some number 2, Lightmap.permute_lights will return [0b00, 0b10, 0b01, 0b11]" do
    input = 0b10

    light_permutations = LightMap.permute_lights(input)

    assert Enum.member?(light_permutations, 0b00)
    assert Enum.member?(light_permutations, 0b01)

    assert Enum.member?(light_permutations, 0b10)
    assert(Enum.member?(light_permutations, 0b11))
  end

  @tag light_map: %{width: 4, toggles: [[0], [0, 1]]}
  test "Given some list 0b00, LightMap.toggles will return 0b10 and 0b11" do
    input = 0b00

    assert LightMap.toggles(input) == [0b01, 0b11]
  end

  @tag light_map: %{width: 4, toggles: [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]]}
  test "Given a permutation 0b0000, toggle will return 0b1000, 0b1010, 0b0100, 0b1100, 0b0101, 0b0011" do
    lights = 0b0000

    assert toggled_lights = LightMap.toggles(lights)

    assert Enum.member?(toggled_lights, 0b1000)
    assert Enum.member?(toggled_lights, 0b1010)
    assert Enum.member?(toggled_lights, 0b0100)
    assert Enum.member?(toggled_lights, 0b1100)
    assert Enum.member?(toggled_lights, 0b0101)
    assert Enum.member?(toggled_lights, 0b0011)
  end

  test "Given some toggles (0) and (0, 1) and a permutation 0b10, toggle will return [{[0], 0b11}, {[0, 1], 0b01}]" do
  end

  @tag visited: [0b00, 0b01]
  test "Given a list of [0b10, 0b01, 0b11], filter_by_visited will return [0b10, 0b11]" do
    input = [0b10, 0b01, 0b11]

    assert Day10.filter_by_visited(input) == [0b10, 0b11]
  end

  test "Given a list [], LightMap.make_toggle will return 0" do
    input = []

    assert LightMap.make_toggle(input) == 0
  end

  test "Given a list [0], LightMap.make_toggle will return 1" do
    input = [0]

    assert LightMap.make_toggle(input) == 1
  end

  test "Given a list [3], LightMap.make_toggle will return 8" do
    input = [3]

    assert LightMap.make_toggle(input) == 8
  end

  test "Given a list [1, 3], LightMap.make_toggle will return 10" do
    input = [1, 3]

    assert LightMap.make_toggle(input) == 10
  end

  test "Given a text string '....', Day10.light_pattern() will return []" do
    input = "...."

    assert Day10.light_pattern(input) == []
  end

  test "Given a text string '.##.', Day10.light_pattern() will return [1, 2]" do
    input = ".##."

    assert Day10.light_pattern(input) == [1, 2]
  end

  test "Given a list of text strings [], Day10.into_toggles will return []" do
    input = []

    assert Day10.into_toggles(input) == []
  end

  test "Given a list of text strings ['3'], Day10.into_toggles will return [[3]]" do
    input = ["3"]

    assert Day10.into_toggles(input) == [[3]]
  end

  test "Given a list of text string ['3', '1,3'], Day10.into_toggles will return [[3], [1,3]]" do
    input = ["3", "1,3"]

    assert Day10.into_toggles(input) == [[3], [1, 3]]
  end

  test "Given an input sequence [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}, decode_line will return 
    a tuple of strings {'.##.', ['3', '1,3', '2', '2,3', '0,2', '0,1'], '3,5,4,7'" do
    input = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"

    assert Day10.decode_line(input) == {".##.", ["3", "1,3", "2", "2,3", "0,2", "0,1"], "3,5,4,7"}
  end

  @tag agent: false
  test "Given the sample input, run_part_1 will return 7" do
    lines = [
      "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}",
      "[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}",
      "[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"
    ]

    assert Day10.run_part_1(lines) == 7
  end

  @tag visited: [{0, 1, 3, 5}, {2, 4, 6, 8}]
  test "Given some input {1, 2, 3, 4}, Visited.visited? will return false " do
    input = {1, 2, 3, 4}

    assert Visited.visited?(input) == false
  end

  @tag visited: [{0, 1, 3, 5}, {2, 4, 6, 8}]
  test "Given some inputt {0, 1, 3, 5}, Visited.visited? will return true" do
    input = {0, 1, 3, 5}

    assert Visited.visited?(input) == true
  end

  @tag visited: [{0, 1, 3, 5}, {2, 4, 6, 8}]
  test "Given some input {0, 3, 6, 9}, Visitted.visit will tag that input as visited" do
    input = {0, 3, 6, 9}

    assert Visited.visited?(input) == false

    Visited.visit(input)

    assert Visited.visited?(input) == true
  end

  @tag jolt_map: %{width: 4, toggles: [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]]}
  test "Given some input {0, 0, 0, 0}, JoltMap.next_generation will return 
    [{0, 0, 0, 1}, {0, 1, 0, 1}, {0, 0, 1, 0}, {0, 0, 1, 1}, {1, 0, 1, 0}, {1, 1, 0, 0}]" do
    input = {0, 0, 0, 0}

    next_generation = JoltMap.next_generation(input)

    assert Enum.member?(next_generation, {0, 0, 0, 1})
    assert Enum.member?(next_generation, {0, 1, 0, 1})
    assert Enum.member?(next_generation, {0, 0, 1, 0})
    assert Enum.member?(next_generation, {0, 0, 1, 1})
    assert Enum.member?(next_generation, {1, 0, 1, 0})
    assert Enum.member?(next_generation, {1, 1, 0, 0})
  end

  @tag jolt_map: %{width: 4, toggles: [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]]}
  test "Given some input {0, 1, 2, 3} JoltMap.next_generation will return 
    [{0, 1, 2, 4}, {0, 2, 2, 4},  {0, 1, 3, 3}, {0, 1, 3, 4}, {1, 1, 3, 3}, {1, 2, 2, 3}" do
    input = {0, 1, 2, 3}

    next_generation = JoltMap.next_generation(input)

    assert Enum.member?(next_generation, {0, 1, 2, 4})
    assert Enum.member?(next_generation, {0, 2, 2, 4})
    assert Enum.member?(next_generation, {0, 1, 3, 3})
    assert Enum.member?(next_generation, {0, 1, 3, 4})
    assert Enum.member?(next_generation, {1, 1, 3, 3})
    assert Enum.member?(next_generation, {1, 2, 2, 3})
  end

  test "Given some input '3,5,4,7' decode_jolts will return {3, 5, 4, 7} " do
    input = "3,5,4,7"

    assert Day10.decode_jolts(input) == {3, 5, 4, 7}
  end

  test "Given some number 4, start_jolts will return {0, 0, 0, 0}" do
    input = 4

    assert Day10.starting_jolts(input) == {0, 0, 0, 0}
  end

  @tag agent: false
  test "Given some input {[[3], [1,3], [2], [2,3], [0,2], [0,1]], {3,5,4,7}} " do
    input = {[[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]], {3, 5, 4, 7}}

    assert Day10.run_one_machine_part_2(input) == 10
  end
end
