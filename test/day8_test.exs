defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

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

  test "Given a pair of junction indices {1, 0}, and a junction-to-circuit map %{1 => 1, 0 => 0} then retrieve_circuits will return {1, 0}" do
    indices = {1, 0}
    junction_to_circuit = %{1 => 1, 0 => 0}

    assert Day8.retrieve_circuits(indices, junction_to_circuit) == {1, 0}
  end

  test "Given a pair of junction indices {1, 0} and a junction-to-circuit map %{1 => 100, 0 => 100} then retrieve_circuits will return {100, 100}" do
    indices = {1, 0}
    junction_to_circuit = %{1 => 100, 0 => 100}

    assert Day8.retrieve_circuits(indices, junction_to_circuit) == {100, 100}
  end

  test "Given a pair of circuit indices {0, 1} and a circuit_to_index map %{0 => [0], 1 => [1]} then join_junction will return a
    circuit id {n,[0, 1], %{n => [0, 1]}}" do
    # Necessary for unique identifies to be generated for each new circuit.
    UniqueCounting.start_link(2)

    indices = {0, 1}
    circuit_to_index = %{0 => [0], 1 => [1]}

    assert Day8.join_junction(indices, circuit_to_index) == {3, [0, 1]}
  end

  test "Given a pair of circuit indices {0, 1} and a circuit_to_index map %{0 => [0, 1], 1 => [2, 3]} then 
    join_junction will return a circuit id {n, [0, 1, 2, 3], %{n => [0, 1, 2, 3]}}" do
    UniqueCounting.start_link(45)

    indices = {0, 1}
    circuit_to_index = %{0 => [0, 1], 1 => [2, 3]}

    assert Day8.join_junction(indices, circuit_to_index) == {46, [0, 1, 2, 3]}
  end

  test "Given a {45, [0, 1, 2, 3]} and a junction-to-circuit map %{0 => 1, 1 => 1, 2 => 3, 3=> 2} then  update_junctions will return 
    %{0 => 45, 1 => 45, 2 => 45, 3 => 45}" do
    update = {45, [0, 1, 2, 3]}
    junction_to_circuit = %{0 => 1, 1 => 1, 2 => 3, 3 => 2}

    assert Day8.update_junctions(update, junction_to_circuit) == %{
             0 => 45,
             1 => 45,
             2 => 45,
             3 => 45
           }
  end
end
