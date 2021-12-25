defmodule Day25 do
  use Memoize

  def part1(data \\ nil) do
    data
    |> get_data()
    |> circle_of_life()
    |> elem(1)
  end

  def circle_of_life(data, i \\ 1) do
    new_data =
      data
      |> Enum.map(&move_rows(&1, :horizontal))
      |> Helpers.transpose()
      |> Enum.map(&move_rows(&1, :vertical))
      |> Helpers.transpose()
      |> print()

    if new_data == data do
      {new_data, i}
    else
      circle_of_life(new_data, i + 1)
    end
  end

  def move_rows(row, direction) do
    row
    |> Enum.concat([row |> Enum.at(0)])
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [c, n] ->
      will_move =
        cond do
          n != "." -> false
          c == "." -> false
          c == ">" and direction == :horizontal -> true
          c == "v" and direction == :vertical -> true
          true -> false
        end

      {c, will_move}
    end)
    |> switch_positions()
  end

  def switch_positions(row) do
    case Enum.find_index(row, &elem(&1, 1)) do
      index when index == length(row) - 1 ->
        move_between(row, -1, 0)
        |> switch_positions()

      nil ->
        row
        |> Enum.map(&elem(&1, 0))

      index ->
        move_between(row, index, index + 1)
        |> switch_positions()
    end
  end

  def move_between(row, i1, i2) do
    {dir, true} = Enum.at(row, i1)

    row
    |> List.replace_at(i1, {".", false})
    |> List.replace_at(i2, {dir, false})
  end

  def print(data) do
    data
    |> Enum.map(fn row ->
      row
      |> Enum.join(" ")
      |> IO.inspect()
    end)

    IO.inspect("")

    data
  end

  def get_data(nil) do
    Api.get_input(25)
    |> get_data()
  end

  def get_data(data) do
    data
    |> String.splitter("\n", trim: true)
    |> Enum.map(fn block ->
      block
      |> String.splitter("", trim: true)
      |> Enum.map(& &1)
    end)
  end
end
