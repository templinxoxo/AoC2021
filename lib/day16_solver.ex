defmodule Day16.Solver do
  def solve({_v, 0, packets}) do
    packets
    |> Enum.map(&solve(&1))
    |> Enum.sum()
  end

  def solve({_v, 1, packets}) do
    packets
    |> Enum.map(&solve(&1))
    |> Helpers.multiply()
  end

  def solve({_v, 2, packets}) do
    packets
    |> Enum.map(&solve(&1))
    |> Enum.min()
  end

  def solve({_v, 3, packets}) do
    packets
    |> Enum.map(&solve(&1))
    |> Enum.max()
  end

  def solve({_v, 4, value}), do: value

  def solve({_v, 5, packets}) do
    [a, b] =
      packets
      |> Enum.map(&solve(&1))

    if a > b, do: 1, else: 0
  end

  def solve({_v, 6, packets}) do
    [a, b] =
      packets
      |> Enum.map(&solve(&1))

    if a < b, do: 1, else: 0
  end

  def solve({_v, 7, packets}) do
    [a, b] =
      packets
      |> Enum.map(&solve(&1))

    if a == b, do: 1, else: 0
  end
end
