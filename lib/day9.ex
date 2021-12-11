defmodule Day9 do
  def part1(data \\ nil) do
    heatmap =
      data
      |> get_data()

    row_2d_lowpoints =
      heatmap
      |> Enum.map(&map_2d_lowpoints(&1))

    col_2d_lowpoints =
      heatmap
      |> Helpers.transpose()
      |> Enum.map(&map_2d_lowpoints(&1))
      |> Helpers.transpose()

    map_3d_lowpoints(row_2d_lowpoints, col_2d_lowpoints)
    |> List.flatten()
    |> Enum.filter(&is_integer(&1))
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end

  def part2(data \\ nil) do
    heatmap =
      data
      |> get_data()

    row_2d_lowpoints =
      heatmap
      |> Enum.map(&map_2d_lowpoints(&1, :horizontal))

    col_2d_lowpoints =
      heatmap
      |> Helpers.transpose()
      |> Enum.map(&map_2d_lowpoints(&1, :vertical))
      |> Helpers.transpose()

    map_3d_lowpoints(row_2d_lowpoints, col_2d_lowpoints)
    |> map_smoke_flow_directions()
    |> split_into_basins()
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.drop([:top])
    |> Map.values()
    |> Enum.sort_by(& &1, &>=/2)
    |> Enum.take(3)
    |> Helpers.multiply()
  end

  def map_2d_lowpoints(row, direction \\ :horizontal) do
    directions =
      case direction do
        :horizontal -> [:left, :right]
        :vertical -> [:up, :down]
      end

    ([:infinite] ++ row ++ [:infinite])
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn [a, b, c] ->
      dir =
        cond do
          b < a and b < c ->
            :low

          b == 9 ->
            :top

          a <= b ->
            directions |> Enum.at(0)

          b <= a ->
            directions |> Enum.at(1)
        end

      {dir, b}
    end)
  end

  def map_3d_lowpoints(row_2d_lowpoints, col_2d_lowpoints) do
    concat_2d_maps_into_3d_martix(row_2d_lowpoints, col_2d_lowpoints)
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn %{vertical: vertical, horizontal: horizontal} = point ->
        with {:low, low} <- horizontal,
             {:low, _low} <- vertical do
          low
        else
          _ ->
            point
        end
      end)
    end)
  end

  def concat_2d_maps_into_3d_martix(row_2d_lowpoints, col_2d_lowpoints) do
    heatmap_width =
      (row_2d_lowpoints
       |> Enum.at(0)
       |> Enum.count()) - 1

    0..(Enum.count(row_2d_lowpoints) - 1)
    |> Enum.map(fn y ->
      0..heatmap_width
      |> Enum.map(fn x ->
        %{
          horizontal: row_2d_lowpoints |> Enum.at(y) |> Enum.at(x),
          vertical: col_2d_lowpoints |> Enum.at(y) |> Enum.at(x)
        }
      end)
    end)
  end

  def map_smoke_flow_directions(map) do
    map
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn point ->
        case point do
          point when is_integer(point) ->
            "b_#{Enum.random(0..100_000)}"

          %{horizontal: {:top, 9}, vertical: {:top, 9}} ->
            :top

          %{horizontal: {:low, _}, vertical: {dir, _}} ->
            dir

          %{vertical: {:low, _}, horizontal: {dir, _}} ->
            dir

          %{vertical: {v_dir, _}, horizontal: {h_dir, _}} ->
            [v_dir, h_dir]
        end
      end)
    end)
  end

  def split_into_basins(map) do
    map
    |> explore(0, 0)
  end

  def explore(map, x, y) do
    # if point is a part of the flow (not including low and high points and out of bounds points)
    new_map =
      if not is_out_of_bounds?(map, x, y) and is_part_of_flow?(map, x, y) do
        # assign basin id to point and all points in betweeen (flow from x to it's lowpoint)
        map
        |> clasiffy_basin_in_point(x, y)
        |> elem(0)
      else
        map
      end

    case next_coordinates(new_map, x, y) do
      # after flow is clasiffied -> go to next coordinates until whole map is not classified
      {new_x, new_y} -> explore(new_map, new_x, new_y)
      :finished -> new_map
    end
  end

  def is_part_of_flow?(map, x, y) do
    directions = [:right, :left, :up, :down]

    case map |> Enum.at(y) |> Enum.at(x) do
      dir when is_atom(dir) -> dir in directions
      dir_list when is_list(dir_list) -> dir_list |> Enum.all?(&(&1 in directions))
      _ -> false
    end
  end

  def is_out_of_bounds?(map, x, y) do
    cond do
      y >= map |> Enum.count() -> true
      x >= map |> Enum.at(y) |> Enum.count() -> true
      true -> false
    end
  end

  def next_coordinates(map, x, y) do
    cond do
      y >= map |> Enum.count() -> :finished
      x >= map |> Enum.at(y) |> Enum.count() -> {0, y + 1}
      true -> {x + 1, y}
    end
  end

  def clasiffy_basin_in_point(map, x, y) do
    case map |> Enum.at(y) |> Enum.at(x) do
      basin_id when is_binary(basin_id) ->
        # it's a lowpoint -> clasiffy flow up to this point
        {map, basin_id}

      direction ->
        # if no lowpoint is found -> continue with the flow
        {next_x, next_y} = next_flow_point(direction, x, y)
        # and assign lowpoint id
        {map, basin_id} = clasiffy_basin_in_point(map, next_x, next_y)
        {map |> Helpers.insert_at(x, y, basin_id), basin_id}
    end
  end

  def next_flow_point(direction, x, y) do
    case direction do
      directions when is_list(directions) ->
        next_flow_point(Enum.at(directions, Enum.random(0..1)), x, y)

      :up ->
        {x, y - 1}

      :down ->
        {x, y + 1}

      :right ->
        {x + 1, y}

      :left ->
        {x - 1, y}
    end
  end

  defp get_data(nil) do
    Api.get_input(9)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn row ->
      row
      |> String.split("")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  defp get_data(_), do: []

  def test_edge_case_data() do
    # ¯\_(ツ)_/¯
    """
    658789891
    547688890
    534566779
    323568879
    012478881
    123568890
    """
  end
end
