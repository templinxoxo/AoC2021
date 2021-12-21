defmodule Day21 do
  def part1(data \\ nil) do
    starting_positions =
      data
      |> get_data()

    rolls = get_rolls()

    play(starting_positions, rolls, 0)
  end

  def get_rolls() do
    1..100
    |> Enum.map(& &1)
    |> List.duplicate(3)
    |> List.flatten()
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.sum(&1))
    |> IO.inspect()
  end

  def play({{_p1, s1}, {_p2, s2}}, _rolls, i) when s1 >= 1000 do
    IO.inspect(i)
    IO.inspect(s2)
    s2 * i * 3
  end

  def play({{_p1, s1}, {_p2, s2}}, _rolls, i) when s2 >= 1000 do
    IO.inspect(i)
    IO.inspect(s1)
    s1 * i * 3
  end

  def play({p1, p2}, rolls, i) when rem(i, 2) == 1 do
    play(
      {p1, move(p2, rolls, i)},
      rolls,
      i + 1
    )
  end

  def play({p1, p2}, rolls, i) when rem(i, 2) == 0 do
    play(
      {move(p1, rolls, i), p2},
      rolls,
      i + 1
    )
  end

  def move({p0, s0}, rolls, i) do
    roll = rolls |> Enum.at(rem(i, 100))

    p = new_position(p0, roll)
    s = s0 + p
    {p, s}
  end

  def new_position(position, roll) do
    case rem(position + roll, 10) do
      0 -> 10
      x -> x
    end
  end

  defp get_data(nil) do
    {{8, 0}, {10, 0}}
  end

  defp get_data({p1, p2}) do
    {{p1, 0}, {p2, 0}}
  end
end
