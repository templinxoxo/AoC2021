defmodule Day15 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> find_shortest_path(:down)
    # |> visualize(
    #   data
    #   |> get_data()
    # )
    |> elem(0)
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> multiply_data()
    |> find_shortest_path(:down)
    |> visualize(
      data
      |> get_data()
      |> multiply_data()
    )
    |> elem(0)
  end

  def find_shortest_path(data, direction) do
    height = data |> length
    width = data |> Enum.at(0) |> length

    0..(height - 1)
    |> Enum.map(fn y ->
      0..(width - 1)
      |> Enum.map(fn x ->
        {:infinity, [], Helpers.value_at(data, x, y)}
      end)
    end)
    |> explore_points(:start, height, width, direction)
  end

  def explore_points(data, :start, height, width, :down) do
    start_point = {0, 0}
    data = Helpers.insert_at(data, 0, 0, {0, [start_point], 0})
    points = nearest_points(start_point, height, width, 1)

    explore_points(data, points, height, width, :down)
    |> List.last()
    |> List.last()
  end

  def explore_points(data, :start, height, width, :up) do
    start_point = {width - 1, height - 1}
    data = Helpers.insert_at(data, width - 1, height - 1, {0, [start_point], 0})
    points = nearest_points(start_point, height, width, -1)

    explore_points(data, points, height, width, :up)
    |> Helpers.value_at(0, 0)
  end

  def explore_points(init_data, points_to_visit, height, width, direction) do
    data =
      points_to_visit
      |> Enum.reduce(init_data, fn {x, y}, data ->
        {_, _, current_value} = Helpers.value_at(data, x, y)

        shortest_path =
          {x, y}
          |> nearest_points(height, width, if(direction == :up, do: 1, else: -1))
          |> Enum.map(fn {x_p, y_p} ->
            {path_value, path, _} = Helpers.value_at(data, x_p, y_p)
            {path_value + current_value, path ++ [{x, y}], current_value}
          end)
          |> Enum.min_by(&elem(&1, 0))

        Helpers.insert_at(data, x, y, shortest_path)
      end)

    next_points_to_visit =
      nearest_points(points_to_visit, height, width, if(direction == :up, do: -1, else: 1))

    case next_points_to_visit do
      [] -> data
      _ -> explore_points(data, next_points_to_visit, height, width, direction)
    end
  end

  def nearest_points(points, height, width, increment) when is_list(points) do
    points
    |> Enum.flat_map(fn {x, y} ->
      [{x + increment, y}, {x, y + increment}]
    end)
    |> Enum.uniq()
    |> Enum.reject(fn {x, y} -> x >= width or y >= height end)
    |> Enum.reject(fn {x, y} -> x < 0 or y < 0 end)
  end

  def nearest_points(point, height, width, increment) do
    nearest_points([point], height, width, increment)
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

  def visualize({_, path, _} = input, data) do
    data
    |> Helpers.matrix_map_with_index(fn p, {x, y} ->
      case {x, y} in path do
        true -> p
        false -> "."
      end
    end)
    |> Enum.map(&(Enum.join(&1, "") |> IO.inspect()))

    input
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
