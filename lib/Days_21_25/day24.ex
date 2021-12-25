defmodule Day24 do
  use Memoize

  def part1(data \\ nil) do
    data
    |> get_data()
    |> solve()
    |> solve(:max)
    |> elem(1)
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> solve(:min)
    |> elem(0)
  end

  def solve(data, dir \\ :max) do
    range =
      case dir do
        :min -> 1..9
        :max -> 9..1
      end

    data
    |> Enum.reduce([{[], %{}}], fn instructions, values ->
      IO.inspect("hodor #{length(values)}")

      values
      |> Enum.uniq_by(&(elem(&1, 1) |> Map.get("z")))
      |> Enum.flat_map(fn {prev, current_values} ->
        range
        |> Enum.map(fn input ->
          new_values = calculate_block({instructions, current_values, input})
          {prev ++ [input], new_values}
        end)
      end)
    end)
    |> Enum.filter(&(elem(&1, 1) |> Map.get("z") == 0))
    |> Enum.map(&(&1 |> elem(0) |> Integer.undigits()))
    |> IO.inspect()
    |> Enum.min_max()
  end

  def calculate_block({instructions, current, input}) do
    instructions
    |> Enum.reduce(current, fn instruction, values ->
      execute(instruction, values, input)
    end)
  end

  def execute(["inp", a], values, input) do
    Map.put(values, a, input)
  end

  def execute(["add", first, second], values, _) do
    v1 = get_value(values, first)
    v2 = get_value(values, second)
    Map.put(values, first, v1 + v2)
  end

  def execute(["mul", first, second], values, _) do
    v1 = get_value(values, first)
    v2 = get_value(values, second)
    Map.put(values, first, v1 * v2)
  end

  def execute(["div", first, second], values, _) do
    v1 = get_value(values, first)
    v2 = get_value(values, second)
    Map.put(values, first, floor(v1 / v2))
  end

  def execute(["mod", first, second], values, _) do
    v1 = get_value(values, first)
    v2 = get_value(values, second)
    Map.put(values, first, rem(v1, v2))
  end

  def execute(["eql", first, second], values, _) do
    v1 = get_value(values, first)
    v2 = get_value(values, second)

    value =
      if v1 == v2 do
        1
      else
        0
      end

    Map.put(values, first, value)
  end

  def get_value(values, key) when key in ["w", "x", "y", "z"], do: Map.get(values, key, 0)
  def get_value(_, value), do: String.to_integer(value)

  def get_data(nil) do
    Api.get_input(24)
    |> get_data()
  end

  def get_data(data) do
    data
    |> String.splitter(["inp"], trim: true)
    |> Enum.map(fn block ->
      ("inp" <> block)
      |> String.splitter(["\n"], trim: true)
      |> Enum.map(&(String.splitter(&1, " ", trim: true) |> Enum.take(3)))
    end)
  end

  def test_data() do
    """
    inp w
    mul x 0
    add x z
    mod x 26
    div z 1
    add x 11
    eql x w
    eql x 0
    mul y 0
    add y 25
    mul y x
    add y 1
    mul z y
    mul y 0
    add y w
    add y 14
    mul y x
    add z y
    inp w
    mul x 0
    add x z
    mod x 26
    div z 1
    add x 13
    eql x w
    eql x 0
    mul y 0
    add y 25
    mul y x
    add y 1
    mul z y
    mul y 0
    add y w
    add y 8
    mul y x
    add z y
    """
  end
end
