defmodule Day11 do
  def part1(data \\ nil, cycles) do
    data
    |> get_data()
    |> sum_flashes(cycles)
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> wait_for_mega_flash()
    |> elem(0)
  end

  def sum_flashes(init_data, cycles) do
    0..(cycles - 1)
    |> Enum.reduce({0, init_data}, fn _, {sum, data} ->
      flash_cycle(data, sum)
    end)
    |> elem(0)
  end

  def wait_for_mega_flash(data, cycle \\ 1) do
    {_sum, new_data} = flash_cycle(data, 0)

    new_data
    |> List.flatten()
    |> Enum.sum()
    |> case do
      0 -> {cycle, new_data}
      _ -> wait_for_mega_flash(new_data, cycle + 1)
    end
  end

  def flash_cycle(data, sum) do
    after_flashing =
      data
      |> do_flash()

    new_flashes =
      after_flashing
      |> List.flatten()
      |> Enum.filter(&(&1 == :flashed))
      |> Enum.count()

    after_reset =
      after_flashing
      |> Enum.map(fn row -> Enum.map(row, fn point -> if point <= 9, do: point, else: 0 end) end)

    {sum + new_flashes, after_reset}
  end

  def do_flash(data) do
    l = length(data) - 1

    points =
      0..l
      |> Enum.map(fn y ->
        0..l
        |> Enum.map(fn x ->
          {{x, y}, 1}
        end)
      end)
      |> List.flatten()

    do_flash(data, points)
  end

  def do_flash(data, points) do
    after_increasing = increase(data, points)

    flashing_points = get_flashing_points(after_increasing, points)

    flashed = flash(after_increasing, flashing_points)

    affected_points =
      flashing_points
      |> Enum.map(&get_affected_points(&1))
      |> List.flatten()
      |> Enum.frequencies()
      |> Enum.to_list()

    case affected_points do
      [] -> flashed
      affected_points -> do_flash(flashed, affected_points)
    end
  end

  def increase(init_data, points) do
    points
    |> Enum.reduce(init_data, fn {{x, y}, value}, data ->
      old_value = Helpers.value_at(data, x, y)

      Helpers.insert_at(data, x, y, get_new_value(old_value, value))
    end)
  end

  def get_new_value(:flashed, _), do: :flashed
  def get_new_value(old_val, new_val), do: old_val + new_val

  # change higher than 9 into :flashed not to count them again
  def flash(init_data, points) do
    points
    |> Enum.reduce(init_data, fn {x, y}, data ->
      new_value =
        case Helpers.value_at(data, x, y) do
          val when val > 9 -> :flashed
          val -> val
        end

      Helpers.insert_at(data, x, y, new_value)
    end)
  end

  # get points that will flash (not flashed and > 9)
  def get_flashing_points(data, points) do
    points
    |> Enum.map(fn {{x, y}, _} ->
      case Helpers.value_at(data, x, y) do
        :flashed -> nil
        val when val > 9 -> {x, y}
        _ -> nil
      end
    end)
    |> Enum.reject(&is_nil(&1))
  end

  def get_affected_points({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.reject(fn {p_x, p_y} ->
      p_x >= 10 || p_x < 0 || p_y >= 10 || p_y < 0
    end)
  end

  defp get_data(nil) do
    Api.get_input(11)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    Regex.split(~r{,|\n}, data)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn row ->
      String.splitter(row, "", trim: true)
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  defp get_data(_), do: []
end
