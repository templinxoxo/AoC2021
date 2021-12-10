defmodule Day10 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> Enum.map(&validate_code(&1))
    |> Enum.filter(&(elem(&1, 0) == :corrupted))
    |> Enum.map(&calculate_score(&1))
    |> Enum.sum()
  end

  def part2(data \\ nil) do
    results =
      data
      |> get_data()
      |> Enum.map(&validate_code(&1))
      |> Enum.filter(&(elem(&1, 0) == :incomplete))
      |> Enum.map(&complete_code(&1))
      |> Enum.map(&calculate_score(&1))
      |> Enum.sort_by(& &1)

    index =
      ((Enum.count(results) - 1) / 2)
      |> round()

    Enum.at(results, index)
  end

  def validate_code(code) do
    correct_chunks = [
      ["(", ")"],
      ["[", "]"],
      ["{", "}"],
      ["<", ">"]
    ]

    chunks =
      code
      |> String.split("")
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(fn [start_char, end_char] ->
        start_char in (correct_chunks |> Enum.map(&Enum.at(&1, 0))) and
          end_char in (correct_chunks |> Enum.map(&Enum.at(&1, 1)))
      end)

    corrupted_chunks = Enum.reject(chunks, &(&1 in correct_chunks))

    cond do
      code == "" ->
        {:correct, nil}

      Enum.count(corrupted_chunks) > 0 ->
        {:corrupted, corrupted_chunks |> List.first()}

      Enum.count(chunks) == 0 ->
        {:incomplete, code}

      true ->
        code
        |> String.splitter(chunks |> Enum.map(&Enum.join(&1, "")))
        |> Enum.join("")
        |> validate_code()
    end
  end

  def complete_code({:incomplete, code}) do
    close_tags = %{
      "(" => ")",
      "[" => "]",
      "{" => "}",
      "<" => ">"
    }

    {:incomplete,
     code
     |> String.splitter("", trim: true)
     |> Enum.reverse()
     |> Enum.map(&Map.get(close_tags, &1))}
  end

  def calculate_score({:corrupted, [_, code]}) do
    char_values = %{
      ")" => 3,
      "]" => 57,
      "}" => 1197,
      ">" => 25137
    }

    Map.get(char_values, code)
  end

  def calculate_score({:incomplete, code}) do
    char_values = %{
      ")" => 1,
      "]" => 2,
      "}" => 3,
      ">" => 4
    }

    code
    |> Enum.reduce(0, fn curr, acc ->
      acc * 5 + Map.get(char_values, curr)
    end)
  end

  def calculate_score(_), do: 0

  defp get_data(nil) do
    Api.get_input(10)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
  end

  defp get_data(_), do: []
end
