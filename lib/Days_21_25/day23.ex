defmodule Day23 do
  def move({data, score}, x0, y0, x1, y1) do
    start_point = Helpers.value_at(data, x0, y0)
    end_point = Helpers.value_at(data, x1, y1)

    if is_move_legit?(x0, y0, x1, y1) and
         is_start_point_legit?(start_point) and
         is_end_point_legit?(end_point) do
      move_len = abs(x1 - x0) + abs(y1 - y0)
      new_score = score + move_len * cost(start_point)

      new_data =
        data
        |> Helpers.insert_at(x0, y0, ".")
        |> Helpers.insert_at(x1, y1, start_point)

      {new_data, new_score}
      |> print()
    else
      IO.inspect({:error, :invalid_move})
      {data, score}
    end
  end

  def print({data, score}) do
    data
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn x ->
        case x do
          nil -> " "
          x -> x
        end
      end)
      |> Enum.join(" ")
      |> IO.inspect()
    end)

    IO.inspect("Cost: #{score}")

    {data, score}
  end

  def is_start_point_legit?(x) when x in ["A", "B", "C", "D"], do: true
  def is_start_point_legit?(_), do: false

  def is_end_point_legit?(x) when x == ".", do: true
  def is_end_point_legit?(_), do: false

  def is_move_legit?(x0, y0, x1, y1), do: y0 != y1 and x0 != x1 and (y0 === 0 or y1 === 0)
  def is_move_legit?(_, _), do: false

  def cost(x) do
    case x do
      "A" -> 1
      "B" -> 10
      "C" -> 100
      "D" -> 1000
    end
  end

  def parse_data(data) do
    {data
     |> String.splitter(["\n"], trim: true)
     |> Enum.map(fn row ->
       row
       |> String.splitter("", trim: true)
       |> Enum.map(fn x ->
         case x do
           "#" -> nil
           " " -> nil
           x -> x
         end
       end)
     end), 0}
  end

  def steps() do
    """
    . . . . . . . . . . .
        D   D   C   C
        D   C   B   A
        D   B   A   C
        B   A   B   A

    . . . . . . . . . . C
        D   D   C   .
        D   C   B   A
        D   B   A   C
        B   A   B   A
    300

    A . . . . . . . . . C
        D   D   C   .
        D   C   B   .
        D   B   A   C
        B   A   B   A
    10

    A . . . . . . . . C C
        D   D   C   .
        D   C   B   .
        D   B   A   .
        B   A   B   A
    400

    A A . . . . . . . C C
        D   D   C   .
        D   C   B   .
        D   B   A   .
        B   A   B   .
    11

    A A . . . . . . . C C
        .   .   C   D
        .   C   B   D
        .   B   A   D
        B   A   B   D
    39_000

    A A . . . . . C . C C
        .   .   C   D
        .   .   B   D
        .   B   A   D
        B   A   B   D
    500

    A A . . . B . C . C C
        .   .   C   D
        .   .   B   D
        .   B   A   D
        .   A   B   D
    70

    . . . . . B . C . C C
        .   .   C   D
        .   .   B   D
        A   B   A   D
        A   A   B   D
    10

    . B . . . B . C . C C
        .   .   C   D
        .   .   B   D
        A   .   A   D
        A   A   B   D
    60

    . B . . . B . C . C C
        .   .   C   D
        A   .   B   D
        A   .   A   D
        A   .   B   D
    8

    . . . . . . . C . C C
        .   .   C   D
        A   .   B   D
        A   B   A   D
        A   B   B   D
    110

    . C . . . . . C . C C
        .   .   .   D
        A   .   B   D
        A   B   A   D
        A   B   B   D
    600

    . C . . . . . C . C C
        A   B   .   D
        A   B   .   D
        A   B   .   D
        A   B   .   D
    138

    . . . . . . . . . . .
        A   B   C   D
        A   B   C   D
        A   B   C   D
        A   B   C   D
    2300
    """

    defmodule Day23 do
      def part2() do
        """
        300
        10
        400
        11
        39_000
        500
        70
        10
        60
        8
        110
        600
        138
        2300
        """
      end
    end
  end
end
