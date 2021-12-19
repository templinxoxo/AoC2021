defmodule Day6 do
  # def part1(data \\ nil) do
  #   data
  #   |> get_data()
  #   |> procreate(80)
  # end
  def part1(data \\ nil) do
    data
    |> get_data()
    |> to_queue()
    |> its_the_cycle_of_life(0, 80)
    |> Enum.sum()
  end

  # def procreate(initial_population, days) do
  #   List.duplicate(nil, days)
  #   |> Enum.reduce(initial_population, fn _, population ->
  #     population
  #     |> Enum.map(fn lanternfish ->
  #       case lanternfish do
  #         0 -> [6, 8]
  #         x -> x - 1
  #       end
  #     end)
  #     |> List.flatten()
  #   end)
  #   |> Enum.count()
  # end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> to_queue()
    |> its_the_cycle_of_life(0, 256)
    |> Enum.sum()
  end

  def its_the_cycle_of_life(queue, step, stop) do
    if step == stop do
      queue
    else
      [spawn | rest] = queue
      new_generation = add_to_queue_at(rest ++ [spawn], spawn, 6)

      its_the_cycle_of_life(new_generation, step + 1, stop)
    end
  end

  def to_queue([], queue), do: queue

  def to_queue([number | rest], queue) do
    to_queue(rest, add_to_queue_at(queue, 1, number))
  end

  def to_queue(numbers) do
    to_queue(numbers, List.duplicate(0, 9))
  end

  def add_to_queue_at(list, to_add, index) do
    {head, [elem | tail]} = Enum.split(list, index)
    head ++ [elem + to_add] ++ tail
  end

  defp get_data(nil) do
    Api.get_input(6)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    Regex.split(~r{,|\n}, data)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer(&1))
  end

  defp get_data(_), do: []
end
