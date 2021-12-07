defmodule Day5 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> Enum.filter(fn [[x1, y1], [x2, y2]] -> x1 == x2 or y1 == y2 end)
    |> Enum.flat_map(&vent_points(&1))
    |> Enum.group_by(& &1)
    |> Map.values()
    |> Enum.filter(&(Enum.count(&1) > 1))
    |> Enum.count()
  end

  def vent_points([[x1, y1], [x2, y2]]) do
    x_range = Helpers.points_in_between(x1, x2)
    y_range = Helpers.points_in_between(y1, y2)

    if x_range |> Enum.count() == y_range |> Enum.count() do
      List.duplicate(0, abs(x1 - x2) + 1)
      |> Enum.with_index()
      |> Enum.map(fn {_, i} -> [x_range |> Enum.at(i), y_range |> Enum.at(i)] end)
    else
      x_range
      |> Enum.flat_map(fn x ->
        y_range
        |> Enum.map(fn y ->
          [x, y]
        end)
      end)
    end
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> Enum.flat_map(&vent_points(&1))
    |> Enum.group_by(& &1)
    |> Map.values()
    |> Enum.filter(&(Enum.count(&1) > 1))
    |> Enum.count()
  end

  defp get_data(nil) do
    Api.get_input(5)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn vent ->
      vent
      |> String.split(" -> ")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(fn points ->
        points
        |> String.split(",")
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.to_integer(&1))
      end)
    end)
  end

  defp get_data(_), do: []
end
