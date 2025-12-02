defmodule Point do
  defstruct x: -1, y: -1
end

defmodule Grid do
  defstruct width: -1, height: -1, map: %{}
end

defmodule Common do
  def open({:error, _msg}, _) do
    raise File.Error, message: "Could not open file."
  end

  def open({:ok, working_dir}, filename) do
    Path.join(working_dir, filename) |> File.open([:read, :utf8])
  end

  def close({:ok, dev}) do
    File.close(dev)
  end

  def close({:ok, dev, lines}) do
    File.close(dev)
    lines
  end

  def read_file({:error, _msg}) do
    raise IO.StreamError, message: "Input stream could not be created."
  end

  def read_file({:ok, stream}) do
    IO.stream(stream, :line) |> Enum.map(fn line -> String.trim(line) end)
  end

  def read_file_pipe({:error, _msg}) do
    raise IO.StreamError, message: "Input stream could not be created."
  end

  def read_file_pipe({:ok, stream}) do
    lines = IO.stream(stream, :line) |> Enum.map(fn line -> String.trim(line) end)
    {:ok, stream, lines}
  end

  def read_raw_pipe({:error, _msg}) do
    raise IO.StreamError, message: "Input stream could not be created."
  end

  def read_raw_pipe({:ok, stream}) do
    lines = IO.stream(stream, :line) |> Enum.map(fn line -> String.trim(line, "\n") end)
    {:ok, stream, lines}
  end

  @spec visualize_map(%{Point => any()}, fun(), integer(), integer()) :: list(list(String.t()))
  def visualize_map(map, value_to_string, width, height) do
    for row_index <- 0..(height - 1) do
      visualize_line(map, value_to_string, row_index, width)
    end
  end

  defp visualize_line(map, value_to_string, current_row, width) do
    for column_index <- 0..(width - 1) do
      Map.get(map, %Point{x: column_index, y: current_row}) |> value_to_string.()
    end
  end
end
