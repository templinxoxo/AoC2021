defmodule Day21.Part2 do
  use Memoize

  def part2(data \\ nil) do
    starting_positions =
      data
      |> get_data()

    play(starting_positions, 0)
    |> Enum.at(0)
  end

  def play(%{p1: p1, p2: p2}, i)
      when i == 0 do
    p =
      move(p1)
      |> calculate_won(p2)

    if p.scores |> Enum.count() == 0 do
      [p.won, p2.won]
    else
      play(%{p1: p, p2: p2}, 1)
    end
  end

  def play(%{p1: p1, p2: p2}, i)
      when i == 1 do
    p =
      move(p2)
      |> calculate_won(p1)

    if p.scores |> Enum.count() == 0 do
      [p.won, p1.won]
    else
      play(%{p1: p1, p2: p}, 0)
    end
  end

  def move(%{scores: scores} = p) do
    rolls = get_rolls()
    roll_possibilities = get_roll_possibilities()

    new_scores =
      scores
      |> Enum.map(fn {position, score, possibility} ->
        rolls
        |> Enum.map(fn roll ->
          new_position = new_position(position, roll)

          [
            {
              new_position,
              score + new_position,
              possibility * (roll_possibilities |> Map.get(roll))
            }
          ]
        end)
      end)
      |> List.flatten()

    # |> Enum.group_by(fn {a, b, _} -> {a, b} end)

    Map.put(p, :scores, new_scores)
  end

  def calculate_won(p1, p2) do
    won =
      p1.scores
      |> Enum.filter(&(elem(&1, 1) >= 21))
      |> Enum.map(fn {_, _, possibility} ->
        p2.scores
        |> Enum.map(fn {_, _, p} ->
          p * possibility
        end)
        |> Enum.sum()
      end)
      |> Enum.sum()

    scores =
      p1.scores
      |> Enum.reject(&(elem(&1, 1) >= 21))

    %{
      won: won + p1.won,
      scores: scores
    }
  end

  defmemo new_position(position, roll), expire: 60 * 60 * 1000 do
    case rem(position + roll, 10) do
      0 -> 10
      x -> x
    end
  end

  defmemo get_roll_possibilities(), expire: 60 * 60 * 1000 do
    1..3
    |> Enum.map(fn x ->
      1..3
      |> Enum.map(fn y ->
        1..3
        |> Enum.map(fn z ->
          x + y + z
        end)
      end)
    end)
    |> List.flatten()
    |> Enum.frequencies()
  end

  def get_rolls(), do: [3, 4, 5, 6, 7, 8, 9]

  defp get_data(nil) do
    get_data({8, 10})
  end

  defp get_data({p1, p2}) do
    %{
      p1: %{
        won: 0,
        scores: [{p1, 0, 1}]
      },
      p2: %{
        won: 0,
        scores: [{p2, 0, 1}]
      }
    }
  end
end
