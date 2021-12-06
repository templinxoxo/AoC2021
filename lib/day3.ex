defmodule Day3 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> Helpers.transpose()
    |> Enum.map(&sort_bits_by_repetition(&1))
    |> Helpers.transpose()
    |> Enum.map(&Integer.undigits(&1, 2))
    |> Helpers.multiply()
  end

  def sort_bits_by_repetition(numbers) do
    numbers
    |> Enum.group_by(& &1)
    |> Map.to_list()
    |> Enum.sort_by(fn {key, _} -> key end, &>=/2)
    |> Enum.sort_by(fn {_, values} -> values |> Enum.count() end, &>=/2)
    |> Enum.map(fn {key, _} -> key end)
  end

  def part2(data \\ nil) do
    bit_report =
      data
      |> get_data()

    bit_indexes_to_iterate =
      bit_report
      |> List.first()
      |> Enum.with_index()
      |> Enum.map(fn {_, i} -> i end)

    [{bit_report, true}, {bit_report, false}]
    |> Enum.map(fn {report, use_most_common} ->
      bit_indexes_to_iterate
      |> Enum.reduce(
        report,
        fn index, acc ->
          remove_by_bit_criteria(acc, index, use_most_common)
        end
      )
      |> List.first()
    end)
    |> Enum.map(&Integer.undigits(&1, 2))
    |> Helpers.multiply()
  end

  def remove_by_bit_criteria(data, _, _) when length(data) == 1, do: data

  def remove_by_bit_criteria(data, index, use_most_common) do
    bit_criteria =
      data
      |> Helpers.transpose()
      |> Enum.at(index)
      |> sort_bits_by_repetition()
      |> Enum.at(if use_most_common, do: 0, else: 1)

    data
    |> Enum.filter(&(Enum.at(&1, index) == bit_criteria))
  end

  defp get_data(nil) do
    Api.get_input(3)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn binary ->
      binary
      |> String.split("")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  defp get_data(_), do: []
end
