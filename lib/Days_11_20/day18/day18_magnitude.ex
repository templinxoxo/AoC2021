defmodule Day18.Magnitude do
  import Day18.Parser

  def magnitude(data) do
    data
    |> from_indexed_list()
    |> calculate_nested
  end

  def calculate_nested(data, times \\ 1)

  def calculate_nested(data, times) when is_list(data) do
    [a, b] =
      data
      |> Enum.take(-2)

    (calculate_nested(a, 3) + calculate_nested(b, 2)) * times
  end

  def calculate_nested(data, times), do: data * times
end
