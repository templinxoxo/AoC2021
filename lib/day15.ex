defmodule Day15 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> find_shortest_path()
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> multiply_data()
    |> find_shortest_path()
  end

  def find_shortest_path(data) do
    data
    |> prepare_empty_matrix
    |> explore_points(:start)
    |> List.last()
    |> List.last()
    |> elem(2)
  end

  def prepare_empty_matrix(data) do
    height = data |> length
    width = data |> Enum.at(0) |> length

    0..(height - 1)
    |> Enum.map(fn y ->
      0..(width - 1)
      |> Enum.map(fn x ->
        {:not_visited, Helpers.value_at(data, x, y), :infinity, nil}
      end)
    end)
  end

  def explore_points(init_data, :start) do
    start_point = {0, 0}
    data = Helpers.insert_at(init_data, 0, 0, {:visited, 0, 0, :start})

    points =
      points_to_visit({start_point, 0, 0, nil}, data)
      |> sort()

    explore_points(data, points)
  end

  def explore_points(init_data, [
        {{x, y} = coords, val, path_val, parent} = start_point | remaining_points
      ]) do
    height = init_data |> length
    width = init_data |> Enum.at(0) |> length

    data = Helpers.insert_at(init_data, x, y, {:visited, val, path_val, parent})

    if coords == {width - 1, height - 1} do
      data
    else
      points =
        points_to_visit(start_point, data)
        |> Enum.concat(remaining_points)
        |> sort()

      explore_points(data, points)
    end
  end

  def points_to_visit({{a, b}, _value, path_value, parent}, data) do
    height = data |> length
    width = data |> Enum.at(0) |> length

    [{a + 1, b}, {a, b + 1}, {a - 1, b}, {a, b - 1}]
    # out of bounds
    |> Enum.reject(fn {x, y} -> x >= width or y >= height end)
    |> Enum.reject(fn {x, y} -> x < 0 or y < 0 end)
    # parent
    |> Enum.reject(fn point -> point == parent end)
    # already visited
    |> Enum.reject(fn {x, y} -> Helpers.value_at(data, x, y) |> elem(0) == :visited end)
    |> Enum.map(fn {x, y} ->
      {:not_visited, value, :infinity, nil} = Helpers.value_at(data, x, y)
      {{x, y}, value, value + path_value, {a, b}}
    end)
  end

  def sort(points) do
    points
    |> Enum.sort_by(&elem(&1, 2))
    |> Enum.uniq_by(&elem(&1, 0))
  end

  def multiply_data(data) do
    0..4
    |> Enum.flat_map(fn to_add1 ->
      data
      |> Enum.map(fn row ->
        0..4
        |> Enum.flat_map(fn to_add2 ->
          Enum.map(row, fn x ->
            case x + to_add1 + to_add2 do
              x when x > 9 ->
                rem(x + 1, 10)

              x ->
                x
            end
          end)
        end)
      end)
    end)
  end

  def get_data(nil) do
    Api.get_input(15)
    |> get_data()
  end

  def get_data(data) when is_binary(data) do
    data
    |> String.splitter("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.splitter("", trim: true)
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  def get_data(_), do: []
end
