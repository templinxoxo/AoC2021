defmodule Day19 do
  def part1(init_data \\ nil) do
    data =
      init_data
      |> get_data()

    data
    |> solve_from_scanner_0()
    |> solve_remaining(data)
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(init_data \\ nil) do
    data =
      init_data
      |> get_data()

    points =
      data
      |> solve_from_scanner_0()
      |> solve_remaining(data)
      |> Enum.map(&elem(&1, 0))

    points
    |> Enum.flat_map(fn [x1, y1, z1] ->
      points
      |> Enum.map(fn [x2, y2, z2] ->
        abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
      end)
    end)
    |> Enum.max()
  end

  def solve_from_scanner_0(data, solved \\ [])

  def solve_from_scanner_0([scanner_0], solved) do
    [{[0, 0, 0], scanner_0}] ++ solved
  end

  def solve_from_scanner_0([scanner_0, scanner_n | data], solved) do
    response = solve_from_scanner(scanner_0, scanner_n)

    solve_from_scanner_0(
      [scanner_0 | data],
      solved ++ [response]
    )
  end

  def solve_from_scanner(scanner_0, scanner_n) do
    scanner_n
    |> rotate()
    |> Enum.map(fn {rotation, points} ->
      coordinates = coordinates_by_intersection(scanner_0, points)
      {rotation, coordinates, points}
    end)
    |> Enum.reject(&is_nil(elem(&1, 1)))
    |> List.first()
    |> translate_points_coordinations()
  end

  def solve_remaining(solved, data) do
    IO.inspect("solve recursive")

    solved_points =
      solved
      |> Enum.reject(&is_nil(&1))
      |> Enum.flat_map(&elem(&1, 1))
      |> Enum.uniq()

    solved_data =
      solved
      |> Enum.with_index()
      |> Enum.filter(&is_nil(elem(&1, 0)))
      |> Enum.map(&elem(&1, 1))
      |> Enum.map(fn index ->
        scanner_n = Enum.at(data, index)

        {index, solve_from_scanner(solved_points, scanner_n)}
      end)
      |> Map.new()

    new_solved =
      solved
      |> Enum.with_index()
      |> Enum.map(fn {points, index} ->
        case points do
          nil -> solved_data |> Map.get(index)
          known_data -> known_data
        end
      end)

    new_solved
    |> Enum.any?(&is_nil(&1))
    |> case do
      true -> solve_remaining(new_solved, data)
      _ -> new_solved
    end
  end

  def coordinates_by_intersection(report1, report2) do
    report1
    |> Enum.flat_map(fn r1_point ->
      report2
      |> Enum.map(fn r2_point ->
        scanner2_coordinates = subtract_points(r1_point, r2_point)

        data =
          report2
          |> Enum.map(fn r2_point_2 ->
            add_points(r2_point_2, scanner2_coordinates)
          end)

        matches =
          data
          |> MapSet.new()
          |> MapSet.intersection(MapSet.new(report1))
          |> Enum.count()

        {scanner2_coordinates, matches}
      end)
    end)
    |> Enum.uniq_by(&elem(&1, 0))
    |> Enum.reject(&(elem(&1, 1) < 3))
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.map(&elem(&1, 0))
    |> List.first()
  end

  def translate_points_coordinations(nil), do: nil

  def translate_points_coordinations({_rotation, [x0, y0, z0], data}) do
    IO.inspect("new solved")

    {[x0, y0, z0],
     data
     |> Enum.map(fn [x, y, z] ->
       [x + x0, y + y0, z + z0]
     end)}
  end

  def rotate(data) do
    get_rotations()
    |> Enum.map(&rotate(data, &1))
  end

  def rotate(data, rotation) when is_list(data) do
    {rotation,
     data
     |> Enum.map(&rotate_coordinates(&1, rotation))}
  end

  def rotate_coordinates(data, {x, y, z}) do
    [
      coordinate_at(data, x),
      coordinate_at(data, y),
      coordinate_at(data, z)
    ]
  end

  def coordinate_at(data, :x), do: data |> Enum.at(0)
  def coordinate_at(data, :y), do: data |> Enum.at(1)
  def coordinate_at(data, :z), do: data |> Enum.at(2)
  def coordinate_at(data, {:negative, position}), do: -coordinate_at(data, position)

  def get_rotations() do
    {:x, :y, :z}
    |> rotate_x()
    |> Enum.flat_map(&rotate_y(&1))
    |> Enum.flat_map(&rotate_z(&1))
    |> Enum.uniq()
  end

  def rotate_x({x, y, z}) do
    [
      {x, y, z},
      {x, z, rotate_point(y)},
      {x, rotate_point(y), rotate_point(z)},
      {x, rotate_point(z), y}
    ]
  end

  def rotate_y({x, y, z}) do
    [
      {x, y, z},
      {z, y, rotate_point(x)},
      {rotate_point(x), y, rotate_point(z)},
      {rotate_point(z), y, x}
    ]
  end

  def rotate_z({x, y, z}) do
    [
      {x, y, z},
      {y, rotate_point(x), z},
      {rotate_point(x), rotate_point(y), z},
      {rotate_point(y), x, z}
    ]
  end

  def rotate_point({:negative, x}), do: x
  def rotate_point(x), do: {:negative, x}

  def add_points([x1, y1, z1], [x2, y2, z2]) do
    [x1 + x2, y1 + y2, z1 + z2]
  end

  def subtract_points([x1, y1, z1], [x2, y2, z2]) do
    [x1 - x2, y1 - y2, z1 - z2]
  end

  defp get_data(nil) do
    Api.get_input(19)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.splitter(["\n\n"], trim: true)
    |> Enum.map(fn report ->
      report
      |> String.splitter(["\n"], trim: true)
      |> Enum.map(& &1)
      |> List.delete_at(0)
      |> Enum.map(fn line ->
        line
        |> String.splitter([","], trim: true)
        |> Enum.map(&String.to_integer(&1))
      end)
    end)
  end

  defp get_data(_), do: []
end
