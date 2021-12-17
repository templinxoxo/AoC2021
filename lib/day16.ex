defmodule Day16 do
  alias Day16.{Decoder, Solver}

  def part1(data \\ nil) do
    data
    |> get_data()
    |> Enum.map(fn code ->
      code
      |> Decoder.decode()
      |> Decoder.flatten()
      |> Enum.map(&elem(&1, 0))
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> Enum.map(fn code ->
      code
      |> Decoder.decode()
      |> Solver.solve()
    end)
    |> Enum.sum()
  end

  defp get_data(nil) do
    Api.get_input(16)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
  end

  defp get_data(_), do: []
end
