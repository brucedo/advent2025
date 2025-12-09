defmodule Day8Test do
  require Logger
  use ExUnit.Case
  doctest Day8

  setup context do
    case context[:agents] do
      false ->
        {}

      _ ->
        {:ok, _counting_pid} =
          if counting_init = context[:counting_init] do
            UniqueCounting.start_link(counting_init)
          else
            UniqueCounting.start_link(0)
          end

        {:ok, _circuit_pid} =
          if circuit_init = context[:circuit_init] do
            CircuitTracker.start_link(circuit_init)
          else
            CircuitTracker.start_link()
          end

        {:ok, _pid} =
          if junction_init = context[:junction_init] do
            JunctionTracker.start_link(junction_init)
          else
            JunctionTracker.start_link()
          end
    end

    # on_exit(fn ->
    #   CircuitTracker.stop(circuit_pid)
    #   JunctionTracker.stop()
    # end)

    :ok
  end

  test "Given two three dimensional points 1, 1, 1 and 2, 2, 2, dist will return SQRT(3)" do
    left = {1, 1, 1}
    right = {2, 2, 2}

    assert Day8.dist(left, right) == :math.sqrt(3)
  end

  test "Given a list of a single pair of points {1, 1, 1} and {2, 2, 2}, sort_dist will return {SQRT3, {1, 1, 1}, {2, 2, 2}}" do
    pairs = [{1, 1, 1}, {2, 2, 2}]

    assert Day8.sort_dist(pairs) == [{:math.sqrt(3), {1, 1, 1}, {2, 2, 2}}]
  end

  test "Given a list of three points [{1, 1, 1}, {2, 2, 2}, {3, 3, 3}], sort_dist will return [{sqrt3, {1, 1, 1}, {2, 2, 2}}, 
    {sqrt3, {2, 2, 2}, {3, 3, 3}}, {sqrt6, {1, 1, 1}, {3, 3, 3}}" do
    pairs = [{1, 1, 1}, {2, 2, 2}, {3, 3, 3}]

    assert Day8.sort_dist(pairs) == [
             {:math.sqrt(3), {1, 1, 1}, {2, 2, 2}},
             {:math.sqrt(3), {2, 2, 2}, {3, 3, 3}},
             {:math.sqrt(12), {1, 1, 1}, {3, 3, 3}}
           ]
  end

  test "Given a list of points [{1, 1, 1}], junction_id will return a map %{ 0 => {1, 1, 1} }" do
    junction = [{1, 1, 1}]

    assert Day8.junction_id(junction) == %{{1, 1, 1} => 0}
  end

  test "Given a list of points [{1, 1, 1}, {2, 2, 2}, {8, 8, 8}] junction_id will return a map 
    %{ {1, 1, 1} => 0 , {2, 2, 2} => 1 , {8, 8, 8} => 2 }" do
    junctions = [{1, 1, 1}, {2, 2, 2}, {3, 3, 3}]

    assert Day8.junction_id(junctions) == %{{1, 1, 1} => 0, {2, 2, 2} => 1, {3, 3, 3} => 2}
  end

  test "Given a list of [{float, point, point}, ...] and a junction_id map, swap_junction_to_id will return [{float, index, index}, ...]" do
    distances = [
      {:math.sqrt(3), {1, 1, 1}, {2, 2, 2}},
      {:math.sqrt(3), {2, 2, 2}, {3, 3, 3}},
      {:math.sqrt(12), {1, 1, 1}, {3, 3, 3}}
    ]

    ids = %{{1, 1, 1} => 0, {3, 3, 3} => 2, {2, 2, 2} => 4}

    assert Day8.swap_junction_to_id(distances, ids) == [
             {:math.sqrt(3), 0, 4},
             {:math.sqrt(3), 4, 2},
             {:math.sqrt(12), 0, 2}
           ]
  end

  @tag junction_init: %{5 => 0, 6 => 0, 7 => 0, 9 => 1, 10 => 1, 12 => 1, 13 => 2, 15 => 2}
  test "Given a pair of junction indices {11, 14}, and a then JunctionTracker.retrieve_circuit_ids will return {}" do
    indices = {1, 0}

    assert JunctionTracker.retrieve_circuit_ids(indices) == {}
  end

  @tag junction_init: %{5 => 0, 6 => 0, 7 => 0, 9 => 1, 10 => 1, 12 => 1, 13 => 2, 15 => 2}
  test "Given a pair of junction indices {5, 9} then JUnctionTracker.retrieve_circuit_ids will return {0, 1}" do
    indices = {5, 9}

    assert JunctionTracker.retrieve_circuit_ids(indices) == {0, 1}
  end

  @tag circuit_init: %{0 => [5, 6, 7], 1 => [9, 10, 12], 2 => [13, 15]}
  @tag junction_init: %{5 => 0, 6 => 0, 7 => 0, 9 => 1, 10 => 1, 12 => 1, 13 => 2, 15 => 2}
  @tag counting_init: 1000
  test "Given a pair of circuit indices {0, 1} and a CircuitTracker with entries for both indices, join_circuits will return a new circuit id 
    comprised of both circuits' junctions and remove the old circuits." do
    joining_circuits = {0, 1}

    {new_circuit_id, _} = CircuitTracker.join_circuits(joining_circuits)

    assert CircuitTracker.circuit_members_of(new_circuit_id) == [5, 6, 7, 9, 10, 12]
    assert CircuitTracker.circuit_members_of(0) == nil
    assert CircuitTracker.circuit_members_of(1) == nil
  end

  @tag circuit_init: %{0 => [5, 6, 7], 1 => [9, 10, 12], 2 => [13, 15]}
  @tag junction_init: %{5 => 0, 6 => 0, 7 => 0, 9 => 1, 10 => 1, 12 => 1, 13 => 2, 15 => 2}
  test "Given a pair of circuit indices {0, 1} and a CircuitTracker with entries for both indices, join_circuits will return a 
    list of junctions affected by the circuit merge" do
    joining_circuits = {0, 1}

    {_, affected_junctions} = CircuitTracker.join_circuits(joining_circuits)

    assert affected_junctions == [5, 6, 7, 9, 10, 12]
  end

  @tag junction_init: %{5 => 0, 6 => 0, 7 => 0, 9 => 1, 10 => 1, 12 => 1, 13 => 2, 15 => 2}
  test "Given a {n, [0, 1, 2, 3]}, JunctionTracker.update_junctions will set n as the circuit of each index in the list " do
    update = {45, [0, 1, 2, 3]}

    JunctionTracker.update_junctions(update)

    assert JunctionTracker.retrieve_circuit_id(0) == 45
    assert JunctionTracker.retrieve_circuit_id(1) == 45
    assert JunctionTracker.retrieve_circuit_id(2) == 45
    assert JunctionTracker.retrieve_circuit_id(3) == 45
  end

  test "Given a list of 20 sample boxes, sort_dist will order the first three pairs as {{162, 817, 812}, {425, 690, 689}}, 
    {{162, 817, 812}, {431, 825, 988}}, and {{906, 360, 560}, {805, 96, 715}}" do
    boxes = [
      {162, 817, 812},
      {57, 618, 57},
      {906, 360, 560},
      {592, 479, 940},
      {352, 342, 300},
      {466, 668, 158},
      {542, 29, 236},
      {431, 825, 988},
      {739, 650, 466},
      {52, 470, 668},
      {216, 146, 977},
      {819, 987, 18},
      {117, 168, 530},
      {805, 96, 715},
      {346, 949, 466},
      {970, 615, 88},
      {941, 993, 340},
      {862, 61, 35},
      {984, 92, 344},
      {425, 690, 689}
    ]

    sorted_set = Day8.sort_dist(boxes)

    {_, first_left, first_right} = hd(sorted_set)
    {_, second_left, second_right} = hd(tl(sorted_set))
    {_, third_left, third_right} = hd(tl(tl(sorted_set)))

    assert {first_left, first_right} == {{162, 817, 812}, {425, 690, 689}}
    assert {second_left, second_right} == {{162, 817, 812}, {431, 825, 988}}
    assert {third_left, third_right} == {{906, 360, 560}, {805, 96, 715}}
  end

  test "Given a list of 20 junction identifiers, create_circuit_map will initialize the circuits to identity" do
    initial_junction_ids = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]

    Day8.create_circuit_map(initial_junction_ids)

    for i <- 0..19 do
      assert CircuitTracker.circuit_members_of(i) == [i]
    end
  end

  @tag agents: false
  test "Given the sample input, run_part_1 will produce a result of 40" do
    boxes = [
      {162, 817, 812},
      {57, 618, 57},
      {906, 360, 560},
      {592, 479, 940},
      {352, 342, 300},
      {466, 668, 158},
      {542, 29, 236},
      {431, 825, 988},
      {739, 650, 466},
      {52, 470, 668},
      {216, 146, 977},
      {819, 987, 18},
      {117, 168, 530},
      {805, 96, 715},
      {346, 949, 466},
      {970, 615, 88},
      {941, 993, 340},
      {862, 61, 35},
      {984, 92, 344},
      {425, 690, 689}
    ]

    assert Day8.run_part_1(boxes, 10) == 40
  end

  @tag agents: false
  test "Given the sample input, the last two junction boxes needed should be 216,146,977 and 117,168,530" do
    boxes = [
      {162, 817, 812},
      {57, 618, 57},
      {906, 360, 560},
      {592, 479, 940},
      {352, 342, 300},
      {466, 668, 158},
      {542, 29, 236},
      {431, 825, 988},
      {739, 650, 466},
      {52, 470, 668},
      {216, 146, 977},
      {819, 987, 18},
      {117, 168, 530},
      {805, 96, 715},
      {346, 949, 466},
      {970, 615, 88},
      {941, 993, 340},
      {862, 61, 35},
      {984, 92, 344},
      {425, 690, 689}
    ]

    assert Day8.run_to_final_boxes(boxes) == {{216, 146, 977}, {117, 168, 530}}
  end

  @tag agents: false
  test "Given the sample input, Day8.run_part_2 returns 25272" do
    boxes = [
      {162, 817, 812},
      {57, 618, 57},
      {906, 360, 560},
      {592, 479, 940},
      {352, 342, 300},
      {466, 668, 158},
      {542, 29, 236},
      {431, 825, 988},
      {739, 650, 466},
      {52, 470, 668},
      {216, 146, 977},
      {819, 987, 18},
      {117, 168, 530},
      {805, 96, 715},
      {346, 949, 466},
      {970, 615, 88},
      {941, 993, 340},
      {862, 61, 35},
      {984, 92, 344},
      {425, 690, 689}
    ]

    assert Day8.run_part_2(boxes) == 25272
  end
end
