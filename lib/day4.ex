defmodule Day4 do
  require Logger

  def run_problem() do
    IO.puts("Starting Day 4, part 1")

    lines =
      Common.open(File.cwd(), "day4")
      |> Common.read_file_pipe()
      |> Common.close()

    part_1_count = run_part_1(lines)

    IO.puts("Part 1 answer: #{part_1_count}")

    part_2_count = run_part_2(lines)

    IO.puts("Part 2 answer: #{part_2_count}")
  end

  def run_part_2(lines) do
    grid = initialize_map(lines)

    run_part_2_iter(grid)
  end

  defp run_part_2_iter(grid) do
    adjusted_map =
      walk_map(grid) |> Enum.reduce(grid, fn neighbor, grid -> add_neighbor(grid, neighbor) end)

    removable_count = count_eligible(adjusted_map)
    Logger.debug("Removable count: #{removable_count}")

    cleaned_map = remove_paper(adjusted_map)

    Logger.debug("#{inspect(cleaned_map)}")

    case removable_count > 0 do
      true -> removable_count + run_part_2_iter(cleaned_map)
      false -> 0
    end
  end

  def run_part_1(lines) do
    grid = initialize_map(lines)

    Logger.debug("Grid before all modifications: #{inspect(grid)}")

    Logger.debug("lines with indices...#{inspect(Enum.with_index(lines))}")

    full_set_of_all_neighbors =
      Enum.with_index(lines)
      |> Enum.flat_map(fn {line, index} -> walk_row(line, index, grid) end)

    updated_counts = sum_neighbors(full_set_of_all_neighbors, grid)

    Logger.debug("updated_counts: #{inspect(updated_counts)}")
    Logger.debug("Just the values: #{inspect(Map.values(updated_counts.map))}")

    reachable =
      Map.values(updated_counts.map)
      |> Enum.filter(fn {symbol, count} -> symbol == "@" && count < 4 end)

    Logger.debug("reachable: #{inspect(reachable)}")

    length(reachable)
  end

  def sum_neighbors(neighbor_list, grid) do
    Enum.reduce(neighbor_list, grid, &add_neighbor(&2, &1))
  end

  def poison_empty_spaces(str_rep, row_num, grid) do
    points =
      String.codepoints(str_rep)
      |> Enum.with_index()
      |> Enum.filter(fn {symbol, _index} -> symbol == "." end)
      |> Enum.map(fn {_symbol, index} -> %Point{x: index, y: row_num} end)

    Enum.reduce(points, grid, fn point, acc_grid ->
      %{acc_grid | map: Map.replace(grid.map, point, 1000)}
    end)
  end

  def walk_row(str_rep, row_num, grid) do
    String.codepoints(str_rep)
    |> Enum.with_index()
    |> Enum.filter(fn {symbol, _index} -> symbol == "@" end)
    |> Enum.map(fn {_, index} -> %Point{x: index, y: row_num} end)
    |> Enum.flat_map(&find_neighbors(&1, grid))
  end

  def walk_map(grid) do
    grid.map
    |> Enum.filter(fn {_point, {symbol, _count}} -> symbol == "@" end)
    |> Enum.flat_map(fn {point, _symbol} -> find_neighbors(point, grid) end)
  end

  def count_eligible(grid) do
    grid.map
    |> Enum.filter(fn {_point, {symbol, count}} -> symbol == "@" && count < 4 end)
    |> Enum.count()
  end

  def remove_paper(grid) do
    updated_map =
      grid.map
      |> Enum.map(fn {point, {symbol, count}} ->
        case count < 4 do
          true -> {point, {".", 0}}
          false -> {point, {symbol, 0}}
        end
      end)
      |> Enum.reduce(%{}, fn {point, value}, acc -> Map.put(acc, point, value) end)

    %{grid | map: updated_map}
  end

  def initialize_map(lines) do
    grid_height = length(lines)
    grid_width = String.length(hd(lines))

    grid = %Grid{width: grid_width, height: grid_height}

    Enum.with_index(lines)
    |> Enum.map(fn {line, index} -> {String.codepoints(line) |> Enum.with_index(), index} end)
    |> Enum.reduce(grid, fn {indexed_line, row}, grid_outer ->
      Enum.reduce(indexed_line, grid_outer, fn {letter, column}, grid_inner ->
        %{grid_inner | map: Map.put(grid_inner.map, %Point{x: column, y: row}, {letter, 0})}
      end)
    end)
  end

  def find_neighbors(point, grid) do
    lesser_x = max(point.x - 1, 0)
    greater_x = min(point.x + 1, grid.width - 1)
    lesser_y = max(point.y - 1, 0)
    greater_y = min(point.y + 1, grid.height - 1)

    # Logger.debug("#{lesser_x}, #{lesser_y}")
    # Logger.debug("#{greater_x}, #{greater_y}")

    neighbors =
      for x <- lesser_x..greater_x, y <- lesser_y..greater_y do
        %Point{x: x, y: y}
      end

    List.delete(neighbors, point)
  end

  def add_neighbor(grid, point) do
    %{
      grid
      | map:
          Map.update!(grid.map, point, fn {symbol, existing_value} ->
            {symbol, existing_value + 1}
          end)
    }
  end
end
