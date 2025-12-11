defmodule Visited do
  use Agent

  def start_link() do
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)
  end

  def start_link(keys) do
    Agent.start_link(fn -> MapSet.new(keys) end, name: __MODULE__)
  end

  def visited?(key) do
    Agent.get(__MODULE__, fn map_set -> MapSet.member?(map_set, key) end)
  end

  def visit(key) do
    Agent.update(__MODULE__, fn map_set -> MapSet.put(map_set, key) end)
  end
end

defmodule LightMap do
  require Logger
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def permute_lights(0) do
    [[]]
  end

  def permute_lights(light_count) do
    false_branches =
      for branch <- permute_lights(light_count - 1) do
        Logger.debug("false branch: #{inspect(branch)}")
        [false | branch]
      end

    true_branches =
      for branch <- permute_lights(light_count - 1) do
        Logger.debug("true branch: #{inspect(branch)}")
        [true | branch]
      end

    Logger.debug("#{inspect(false_branches)}, #{inspect(true_branches)}")

    false_branches ++ true_branches
  end
end

defmodule Day10 do
end
