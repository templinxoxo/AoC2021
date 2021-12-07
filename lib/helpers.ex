defmodule Helpers do
  def multiply(data) do
    data
    |> Enum.reduce(1, fn value, acc -> acc * value end)
  end

  def transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
  end

  def points_in_between(a1, a2) do
    positive = a1 < a2

    if positive do
      a1..a2
    else
      a2..a1
    end
  end
end
