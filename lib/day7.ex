defmodule Day7 do
  def part1(data \\ nil) do
    positions =
      data
      |> get_data()

    min = Enum.min(positions)

    max = Enum.max(positions)

    range = Helpers.points_in_between(min, max)

    range
    |> List.duplicate(positions |> Enum.count())
    |> Enum.with_index()
    |> Enum.map(fn {movement_cost, index} ->
      Enum.map(movement_cost, &abs(&1 - Enum.at(positions, index)))
    end)
    |> Helpers.transpose()
    |> Enum.map(&Enum.sum(&1))
    |> Enum.with_index()
    |> Enum.min_by(fn {sum, _} -> sum end)
    |> elem(0)
  end

  def part2(data \\ nil) do
    positions =
      data
      |> get_data()

    min = Enum.min(positions)

    max = Enum.max(positions)

    range =
      Helpers.points_in_between(min, max)
      |> Enum.reduce([], fn curr, acc -> acc ++ [curr + last(acc)] end)

    reversed_range = range |> Enum.reverse()

    positions
    |> Enum.map(fn position ->
      {pt2, _} = range |> Enum.split(max - position)
      {_, pt1} = reversed_range |> Enum.split(max - position)

      (pt1 |> add_finishing_zero()) ++ (pt2 |> remove_leading_zero())
    end)
    |> Helpers.transpose()
    |> Enum.map(&Enum.sum(&1))
    |> Enum.with_index()
    |> Enum.min_by(fn {sum, _} -> sum end)
    |> elem(0)
  end

  def last([]), do: 0
  def last(list), do: List.last(list)

  def remove_leading_zero([0 | list]), do: list
  def remove_leading_zero(list), do: list

  def add_finishing_zero(list) do
    case List.last(list) do
      0 -> list
      _ -> list ++ [0]
    end
  end

  defp get_data(nil) do
    Api.get_input(7)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    Regex.split(~r{,|\n}, data)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer(&1))
  end

  defp get_data(_), do: []
end
