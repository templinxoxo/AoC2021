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
  end
end
