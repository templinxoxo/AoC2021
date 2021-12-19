defmodule Day18 do
  import Day18.Processor
  import Day18.Magnitude

  @spec part1(nonempty_maybe_improper_list) :: any
  def part1() do
    Day18.Data.data()
    |> part1()
  end

  def part1(data) do
    calculate(data)
    |> magnitude()
  end

  def part2(data \\ Day18.Data.data()) do
    data
    |> uniq_pairs()
    |> Enum.map(fn pair ->
      pair
      |> calculate()
      |> magnitude()
    end)
    |> Enum.max()
  end

  def uniq_pairs(data) do
    size = length(data) - 1

    0..(size - 1)
    |> Enum.flat_map(fn x ->
      (x + 1)..size
      |> Enum.flat_map(fn y ->
        a = data |> Enum.at(x)
        b = data |> Enum.at(y)
        [[a, b], [b, a]]
      end)
    end)
  end
end
