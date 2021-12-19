defmodule Day2 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> Enum.map(&translate_position(&1))
    |> Enum.group_by(fn {key, _} -> key end)
    |> Map.values()
    |> Enum.map(
      &(&1
        |> Enum.map(fn {_, value} -> value end)
        |> Enum.sum())
    )
    |> Helpers.multiply()
  end

  def translate_position({"up", value}), do: {"down", -value}
  def translate_position(entry), do: entry

  def part2(data \\ nil) do
    data
    |> get_data()
    |> Enum.map(&translate_position(&1))
    |> Enum.reduce([], &add_aim_to_entry(&1, &2))
    |> Enum.flat_map(&apply_movement_depth_change(&1))
    |> Enum.group_by(fn {key, _} -> key end)
    |> Map.values()
    |> Enum.map(
      &(&1
        |> Enum.map(fn {_, value} -> value end)
        |> Enum.sum())
    )
    |> Helpers.multiply()
  end

  def add_aim_to_entry({movement, value} = entry, entries) do
    aim =
      entries
      |> get_current_aim()
      |> calculate_aim(entry)

    [{movement, value, aim} | entries]
  end

  def get_current_aim([]), do: 0

  def get_current_aim(entries) when is_list(entries) do
    [{_, _, aim} | _] = entries

    aim
  end

  def get_current_aim(_), do: 0

  def calculate_aim(aim, {"down", value}), do: aim + value
  def calculate_aim(aim, _), do: aim

  def apply_movement_depth_change({"forward", value, aim}),
    do: [{"forward", value}, {"down", value * aim}]

  def apply_movement_depth_change({"down", _, _}), do: []

  defp get_data(nil) do
    Api.get_input(2)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn entry ->
      [direction, value] = String.split(entry, " ")
      {direction, String.to_integer(value)}
    end)
  end

  defp get_data(_), do: []
end
