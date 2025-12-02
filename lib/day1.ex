defmodule Day1 do
  require Logger

  def run_problem() do
    IO.puts("Starting Day 1, part 1")

    lines =
      Common.open(File.cwd(), "day1")
      |> Common.read_file_pipe()
      |> Common.close()

    click_count_part_1 = run_part_1(lines)

    IO.puts("Click count from part 1: #{click_count_part_1}")

    click_count_part_2 = run_part_2(lines)
    IO.puts("Click count from part 2: #{click_count_part_2}")
  end

  def run_part_2(lines) do
    Enum.map(lines, &decode/1)
    |> Enum.reduce({50, 0}, fn {_status, {direction, spin_count}}, {combo, zero_count} ->
      Logger.debug(
        "direction: #{inspect(direction)}, number of spins: #{inspect(spin_count)}, last combination: #{inspect(combo)}, zero click count: #{inspect(zero_count)}"
      )

      # There is a problem here.  If the combo is already 0, and we subtract a spin_count that is less than 100, 
      # then that drops below 0 - but does not count as an additional 0 click.  However, floor_div always rounds 
      # down - which means it counts that as a zero click, even though we did not click over 0.
      # This taints the whole subtraction side: if we are at 0 and subtract 102, then we will click past 0 once.
      # We will not click twice - but because we are at -102, floor_div returns 2.
      # The converse case - addition - is true if we start at 100, and then add any value < 100, floor_div will give us 
      # a return of 1 - even though we have not clicked over 100 from this turn.  The only reason it's probably not an 
      # issue is that we are normalizing to 0 <= count < 100 - so we should never see 100.  But we have to be careful to 
      # not introduce that case.
      # If we go back to floor_div on the rotation count, that will give us an honest count of how many times the 
      # rotation will flip us over the 100 mark.  We still need to account for the remainder flipping us over or under, 
      # though.  I think I need to account for left and right cases separately, though.  Left I need to specifically 
      # confirm whether I am at 0, and if I am at 0 then the total count is just the modulo rotation count.
      # Actually - if we just use the rotation_count modulo 100, then it would be impossible for us to flip if we are at 
      # 0.  Even a right 99 or left 99 will only move us to either 99 or 1 - neither of which should trigger a click count.
      # Okay.  So, new plan: take base click count to be spin_count floor_div 100.  If combo == 0, then just add or 
      # subtract spin_count modulo 100 - otherwise, add or subtract and test for flip.  If flip, then add one more.
      base_click_count = Integer.floor_div(spin_count, 100)
      remaining_spin = Integer.mod(spin_count, 100)

      {updated_combination, additional_click} =
        case direction do
          :L -> rot_left(combo, remaining_spin)
          :R -> rot_right(combo, remaining_spin)
        end

      {updated_combination, zero_count + base_click_count + additional_click}

      # updated_combo =
      #   case direction do
      #     :L -> combo - spin_count
      #     :R -> combo + spin_count
      #   end
      # zero_clicks = abs(Integer.floor_div(updated_combo, 100))

      # clamped_combo = dial(combo, {status, {direction, spin_count}})

      # case updated_combo == 0 do
      #   true -> {clamped_combo, zero_count + zero_clicks + 1}
      #   false -> {clamped_combo, zero_count + zero_clicks}
      # end
    end)
    |> elem(1)
  end

  def rot_right(100, remaining_spin) do
    {remaining_spin, 0}
  end

  def rot_right(current_combination, remaining_spin) do
    spun = current_combination + remaining_spin

    cond do
      spun == 100 -> {0, 1}
      spun < 100 -> {spun, 0}
      spun > 100 -> {spun - 100, 1}
    end
  end

  def rot_left(0, remaining_spin) do
    {100 - remaining_spin, 0}
  end

  def rot_left(current_combination, remaining_spin) do
    spun = current_combination - remaining_spin

    cond do
      spun == 0 -> {spun, 1}
      spun < 0 -> {spun + 100, 1}
      spun > 0 -> {spun, 0}
    end
  end

  def run_part_1(lines) do
    Enum.map(lines, &decode/1)
    |> Enum.reduce({50, 0}, fn direction, {combo, count} ->
      result = dial(combo, direction)

      if result == 0 do
        {result, count + 1}
      else
        {result, count}
      end
    end)
    |> elem(1)
  end

  def decode(line) do
    String.split_at(line, 1) |> decode_parts()
  end

  defp decode_parts({"L", number}) do
    case do_integer_bit(number) do
      {:ok, number} -> {:ok, {:L, number}}
      x -> x
    end
  end

  defp decode_parts({"R", number}) do
    case do_integer_bit(number) do
      {:ok, number} -> {:ok, {:R, number}}
      x -> x
    end
  end

  defp decode_parts(_misdirection) do
    {:error, "Must be in the form R|L[0-9]+"}
  end

  defp do_integer_bit(string_repr) do
    case Integer.parse(string_repr) do
      {number, ""} -> {:ok, number}
      {_number, _x} -> {:error, "Must be in the form R|L[0-9]+"}
      :error -> {:error, "Must be in the form R|L[0-9]+"}
    end
  end

  def dial(number, {:ok, {:L, amount}}) do
    modulod = Integer.mod(number - amount, 100)

    case modulod < 0 do
      true -> modulod + 100
      false -> modulod
    end
  end

  def dial(number, {:ok, {:R, amount}}) do
    Integer.mod(number + amount, 100)
  end

  def dial(_, {:error, msg}) do
    {:error, msg}
  end

  def adjust(number) do
    {Integer.mod(number, 100), Integer.floor_div(number, 100)}
  end
end
