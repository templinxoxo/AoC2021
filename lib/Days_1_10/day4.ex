defmodule Day4 do
  def part1(data \\ nil) do
    {numbers, boards} =
      data
      |> get_data()

    draw_numbers(numbers, boards, 0, &select_first_bingo_board/1)
    |> calculate_score()
  end

  def select_first_bingo_board(boards) do
    case boards |> Enum.filter(&(elem(&1, 0) == :bingo)) do
      [{:bingo, board, _step} | _] -> {:selected, board}
      _ -> boards |> Enum.map(&elem(&1, 1))
    end
  end

  def part2(data \\ nil) do
    {numbers, boards} =
      data
      |> get_data()

    draw_numbers(numbers, boards, 0, &select_last_bingo_board/1)
    |> calculate_score()
  end

  def select_last_bingo_board(boards) do
    case boards |> Enum.filter(&(elem(&1, 0) == :try_again)) do
      [] ->
        board =
          boards
          |> Enum.sort_by(fn {_, _, step} -> step end)
          |> List.last()
          |> elem(1)

        {:selected, board}

      failed_boards ->
        failed_boards |> Enum.map(&elem(&1, 1))
    end
  end

  def draw_numbers(numbers, boards, step, board_selection_fcn) do
    drawn_numbers = numbers |> Enum.take(step)

    selected_boards =
      boards
      |> Enum.map(fn board ->
        case bingo?(board, drawn_numbers) do
          true -> {:bingo, board, step}
          false -> {:try_again, board}
        end
      end)
      |> board_selection_fcn.()

    case selected_boards do
      {:selected, board} -> {board, drawn_numbers}
      new_boards -> draw_numbers(numbers, new_boards, step + 1, board_selection_fcn)
    end
  end

  def bingo?(board, numbers) do
    [board, board |> Helpers.transpose()]
    |> Enum.flat_map(& &1)
    |> Enum.any?(&row_bingo?(&1, numbers))
  end

  def row_bingo?(row, numbers) do
    Enum.all?(row, &(&1 in numbers))
  end

  def calculate_score({board, drawn_numbers}) do
    board_sum =
      board
      |> List.flatten()
      |> Enum.reject(&(&1 in drawn_numbers))
      |> Enum.sum()

    board_sum * (drawn_numbers |> List.last())
  end

  def calculate_score(_), do: 0

  defp get_data(nil) do
    Api.get_input(4)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    [numbers_raw | boards_raw] =
      data
      |> String.split("\n\n")
      |> Enum.reject(&(&1 == ""))

    numbers =
      numbers_raw
      |> String.split(",")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer(&1))

    boards =
      boards_raw
      |> Enum.map(fn board ->
        board
        |> String.split("\n")
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(fn row ->
          row
          |> String.split(" ")
          |> Enum.reject(&(&1 == ""))
          |> Enum.map(&String.to_integer(&1))
        end)
      end)

    {numbers, boards}
  end

  defp get_data(_), do: []
end
