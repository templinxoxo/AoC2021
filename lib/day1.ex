defmodule Day1 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [prev, next] -> prev < next end)
    |> Enum.count()
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [prev, next] -> prev < next end)
    |> Enum.count()
  end

  defp get_data(nil) do
    Api.get_input(1)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer(&1))
  end

  defp get_data(_), do: []
end
