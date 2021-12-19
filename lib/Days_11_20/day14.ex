defmodule Day14 do
  def part1(data \\ nil) do
    {initial_template, pair_insertions} =
      data
      |> get_data()

    template = parse_template(initial_template)

    apply_pair_insertion(template, pair_insertions, 10)
    |> measure_polymer_strength(initial_template)
  end

  def part2(data \\ nil) do
    {initial_template, pair_insertions} =
      data
      |> get_data()

    template = parse_template(initial_template)

    apply_pair_insertion(template, pair_insertions, 40)
    |> measure_polymer_strength(initial_template)
  end

  def parse_template(template) do
    template
    |> String.splitter("", trim: true)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.frequencies()
    |> Map.to_list()
  end

  def apply_pair_insertion(initial_template, pair_insertions, steps_left) do
    template =
      initial_template
      |> Enum.reduce(%{}, fn {key, count}, sum ->
        [l1, l3] = String.splitter(key, "", trim: true) |> Enum.take(2)
        l2 = Map.get(pair_insertions, key)

        sum
        |> Map.update("#{l1}#{l2}", count, fn x -> x + count end)
        |> Map.update("#{l2}#{l3}", count, fn x -> x + count end)
      end)
      |> Map.to_list()

    if steps_left > 1 do
      apply_pair_insertion(template, pair_insertions, steps_left - 1)
    else
      template
    end
  end

  def measure_polymer_strength(template, initial_template) do
    last_letter = String.at(initial_template, -1)

    letter_count =
      template
      |> Enum.reduce(%{}, fn {key, count}, sum ->
        [l1, _] = String.splitter(key, "", trim: true) |> Enum.take(2)

        sum
        |> Map.update(l1, count, fn x -> x + count end)
      end)
      |> Map.update(last_letter, 1, fn x -> x + 1 end)
      |> Map.to_list()
      |> Enum.map(&elem(&1, 1))
      |> Enum.sort_by(& &1)

    Enum.max(letter_count) - Enum.min(letter_count)
  end

  defp get_data(nil) do
    Api.get_input(14)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    [initial_template, pair_insertions_raw] =
      data
      |> String.splitter("\n\n", trim: true)
      |> Enum.take(2)

    pair_insertions =
      pair_insertions_raw
      |> String.splitter(["\n", " ", "->"], trim: true)
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple(&1))
      |> Map.new()

    {initial_template, pair_insertions}
  end

  defp get_data(_), do: []
end
