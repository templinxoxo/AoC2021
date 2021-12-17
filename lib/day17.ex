defmodule Day17 do
  def part1(data \\ nil) do
    [_x, {_, y2}] =
      data
      |> get_data()

    -calculate_y_gravitional_pull(-y2 - 1)
  end

  def part2(data \\ nil) do
    [x, y] =
      data
      |> get_data()

    x_values = calculate_possible_x_values(x)

    possible_y_values_by_steps =
      x_values
      |> get_uniq_steps_number()
      |> IO.inspect()
      |> Enum.map(&{&1, calculate_possible_y_values_by_steps(&1, y)})
      |> Map.new()

    x_values
    |> IO.inspect()
    |> Enum.flat_map(fn {x, steps} ->
      steps
      |> Enum.flat_map(fn {key, val} ->
        key =
          case key do
            :max -> val
            key -> key
          end

        possible_y_values_by_steps
        |> Map.get(IO.inspect(key), [])
        |> IO.inspect()
        |> Enum.map(&{x, &1})
      end)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def calculate_possible_x_values({x1, x2} = x) do
    1..x2
    |> Enum.map(fn velocity ->
      calculate_possible_x_velocity(velocity, x)
    end)
    |> Enum.with_index()
    |> Enum.reject(fn {steps, _i} -> steps == [] end)
    |> Enum.map(fn {steps, i} -> {i + 1, steps} end)
    |> Enum.map(fn {init_x, steps} ->
      steps =
        steps
        |> Enum.filter(fn {key, sum} ->
          key == :max or (sum >= x1 and sum <= x2)
        end)
        |> Enum.sort_by(&elem(&1, 1))

      {init_x, steps}
    end)
    |> Enum.reject(fn {_i, steps} -> steps == [] end)
  end

  def calculate_possible_x_velocity(velocity, {x1, x2} = x, [{_, sum} | _] = steps \\ [{0, 0}]) do
    cond do
      velocity == 0 && sum > x1 && sum < x2 ->
        [{:max, {:max, Enum.count(steps)}}] ++ steps

      velocity == 0 ->
        steps

      sum > x2 ->
        steps

      true ->
        calculate_possible_x_velocity(
          velocity - 1,
          x,
          [{Enum.count(steps), sum + velocity}] ++ steps
        )
    end
  end

  def get_uniq_steps_number(steps) do
    steps
    |> Enum.map(&elem(&1, 1))
    |> List.flatten()
    |> Enum.map(fn {key, val} ->
      case key do
        :max -> val
        key -> key
      end
    end)
    |> Enum.group_by(& &1)
    |> Map.to_list()
    |> Enum.map(&elem(&1, 0))
  end

  def calculate_y_gravitional_pull(step, sum \\ 0) do
    case step do
      0 -> sum
      step -> calculate_y_gravitional_pull(step - 1, sum - step)
    end
  end

  def calculate_possible_y_values_by_steps(steps, y) when is_list(steps) do
    steps
    |> Enum.map(&{&1, calculate_possible_y_values_by_steps(&1, y)})
  end

  def calculate_possible_y_values_by_steps({:max, min_steps}, {y1, y2}) do
    y2..-y2
    |> Enum.filter(&will_hit_area_y?(&1, {y1, y2}, min_steps - 2))
  end

  def calculate_possible_y_values_by_steps(steps, {y1, y2}) do
    gravitional_pull = calculate_y_gravitional_pull(steps - 1)

    [range_1, range_2] =
      [y1, y2]
      |> Enum.map(&(&1 - gravitional_pull))
      |> Enum.map(&(&1 / steps))

    floor(range_1)..ceil(range_2)
  end

  def will_hit_area_y?(curr_v, {y1, y2}, min_step_count, init_y \\ 0) do
    y = init_y + curr_v

    cond do
      y >= y2 and y <= y1 and min_step_count < 0 -> true
      y < y2 -> false
      true -> will_hit_area_y?(curr_v - 1, {y1, y2}, min_step_count - 1, y)
    end
  end

  defp get_data(nil), do: [{70, 125}, {-121, -159}]
  defp get_data(data), do: data
end
