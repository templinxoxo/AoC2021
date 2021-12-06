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
end
