defmodule Day8 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> Enum.flat_map(&Enum.at(&1, 1))
    |> Enum.filter(&(String.length(&1) in [2, 3, 4, 7]))
    |> Enum.count()
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> Enum.map(&solve_puzzle(&1))
    |> Enum.sum()
  end

  #   111
  #  2   3
  #  2   3
  #   444
  #  5   6
  #  5   6
  #   777
  # key to solving every number is to know what codes strokes 2, 4 and 5
  def solve_puzzle([sample, puzzle]) do
    numbers = 0..9 |> Enum.map(&{&1, nil}) |> Enum.into(%{})

    numbers_by_strokes =
      sample
      |> Enum.map(&fix_order(&1))
      |> Enum.group_by(&String.length(&1))

    numbers =
      numbers
      |> Map.put(1, numbers_by_strokes[2] |> List.first())
      |> Map.put(4, numbers_by_strokes[4] |> List.first())
      |> Map.put(7, numbers_by_strokes[3] |> List.first())
      |> Map.put(8, numbers_by_strokes[7] |> List.first())
      |> solve_for_9(numbers_by_strokes[6])
      |> solve_for_0(numbers_by_strokes[6])
      |> solve_for_6(numbers_by_strokes[6])
      |> solve_for_3(numbers_by_strokes[5])
      |> solve_for_2(numbers_by_strokes[5])
      |> solve_for_5(numbers_by_strokes[5])

    decoder = Map.new(numbers, fn {key, val} -> {val, key} end)

    puzzle
    |> Enum.map(&fix_order(&1))
    |> Enum.map(&decoder[&1])
    |> Enum.join("")
    |> String.to_integer()
  end

  def fix_order(number) do
    number
    |> String.split("")
    |> Enum.sort_by(& &1)
    |> Enum.join("")
  end

  def contains_number_or_stroke?(number, number_or_stroke) do
    number_or_stroke
    |> String.split("")
    |> Enum.all?(&String.contains?(number, &1))
  end

  def insert_into(value, map, key) do
    map |> Map.put(key, value)
  end

  def solve_for_9(numbers, possible_numbers) do
    possible_numbers
    |> Enum.find(fn number ->
      contains_number_or_stroke?(number, numbers[4])
    end)
    |> insert_into(numbers, 9)
  end

  def solve_for_0(numbers, possible_numbers) do
    possible_numbers
    |> Enum.reject(&(&1 == numbers[9]))
    |> Enum.filter(&contains_number_or_stroke?(&1, numbers[7]))
    |> List.first()
    |> insert_into(numbers, 0)
  end

  def solve_for_6(numbers, possible_numbers) do
    possible_numbers
    |> Enum.reject(&(&1 in [numbers[9], numbers[0]]))
    |> List.first()
    |> insert_into(numbers, 6)
  end

  def solve_for_3(numbers, possible_numbers) do
    possible_numbers
    |> Enum.filter(&contains_number_or_stroke?(&1, numbers[7]))
    |> List.first()
    |> insert_into(numbers, 3)
  end

  def solve_for_2(numbers, possible_numbers) do
    stroke_5 = missing_strokes(numbers[9]) |> List.first()

    possible_numbers
    |> Enum.reject(&(&1 == numbers[3]))
    |> Enum.filter(&contains_number_or_stroke?(&1, stroke_5))
    |> List.first()
    |> insert_into(numbers, 2)
  end

  def solve_for_5(numbers, possible_numbers) do
    possible_numbers
    |> Enum.reject(&(&1 in [numbers[3], numbers[2]]))
    |> List.first()
    |> insert_into(numbers, 5)
  end

  def missing_strokes(number) do
    "abcdefg"
    |> String.split("")
    |> Enum.reject(&String.contains?(number, &1))
  end

  def insert_at(list, to_add, index) do
    {head, [elem | tail]} = Enum.split(list, index)
    head ++ [elem + to_add] ++ tail
  end

  defp get_data(nil) do
    Api.get_input(8)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    Regex.split(~r{\n|\|}, data)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn row ->
      row
      |> String.split(" ")
      |> Enum.reject(&(&1 == ""))
    end)
    |> Enum.chunk_every(2)
  end

  defp get_data(_), do: []
end
