defmodule Day13 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> fold(break: true)
    |> Enum.count()
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> fold()
    |> visualise()
  end

  def fold({data, instructions}, opts \\ []) do
    [instruction | instructions] = instructions

    data_after_fold =
      data
      |> Enum.map(&fold_point(&1, instruction))
      |> Enum.uniq()

    if Keyword.get(opts, :break, false) or instructions == [] do
      data_after_fold
    else
      fold({data_after_fold, instructions})
    end
  end

  def fold_point({x, y}, {"y", fold_line}) do
    {x, transpose_point(y, fold_line)}
  end

  def fold_point({x, y}, {"x", fold_line}) do
    {transpose_point(x, fold_line), y}
  end

  def transpose_point(point, fold_line) when point < fold_line, do: point

  def transpose_point(point, fold_line), do: fold_line - (point - fold_line)

  def visualise(points) do
    max_x = points |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = points |> Enum.map(&elem(&1, 1)) |> Enum.max()

    0..max_y
    |> Enum.map(fn y ->
      0..max_x
      |> Enum.map(fn x ->
        if {x, y} in points do
          "#"
        else
          " "
        end
      end)
      |> Enum.join(" ")
      |> IO.inspect()
    end)

    nil
  end

  defp get_data(nil) do
    Api.get_input(13)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    [points_raw, instructions_raw] =
      data
      |> String.splitter("\n\n", trim: true)
      |> Enum.take(2)

    points =
      points_raw
      |> String.splitter("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.splitter(",", trim: true)
        |> Enum.map(&String.to_integer(&1))
        |> List.to_tuple()
      end)

    instructions =
      instructions_raw
      |> String.splitter(["fold along ", "\n"], trim: true)
      |> Enum.map(fn row ->
        row
        |> String.splitter("=", trim: true)
        |> Enum.take(2)
      end)
      |> Enum.map(fn [axis, value] ->
        {axis, String.to_integer(value)}
      end)

    {points, instructions}
  end

  defp get_data(_), do: []
end
