defmodule Helpers do
  def multiply(data) do
    data
    |> Enum.reduce(1, fn value, acc -> acc * value end)
  end
end
