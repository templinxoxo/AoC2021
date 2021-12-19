defmodule Day12 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> get_paths_map()
    |> explore()
    |> Enum.filter(&(elem(&1, 0) == :finished))
    |> Enum.count()
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> get_paths_map()
    |> explore(allow_small_cave_repetition: true)
    |> Enum.filter(&(elem(&1, 0) == :finished))
    |> Enum.count()
  end

  def explore(path_map, opts \\ []) do
    explore([{:exploring, ["start"]}], path_map, opts)
  end

  def explore(paths, path_map, opts) do
    paths_to_explore = Enum.filter(paths, &(elem(&1, 0) == :exploring))
    finished_paths = Enum.reject(paths, &(elem(&1, 0) == :exploring))

    case paths_to_explore do
      [] ->
        finished_paths

      paths_to_explore ->
        paths_to_explore
        |> Enum.flat_map(fn {_, path} ->
          path_map[List.last(path)]
          |> Enum.map(&validate_new_path(path, &1, opts))
        end)
        |> Enum.concat(finished_paths)
        |> explore(path_map, opts)
    end
  end

  def validate_new_path(path, next_step, opts) do
    cond do
      next_step == "start" ->
        {:error, path ++ ["start"]}

      next_step == "end" ->
        {:finished, path ++ ["end"]}

      next_step in path and String.match?(next_step, ~r/^[[:lower:]]+$/) ->
        case Keyword.get(opts, :allow_small_cave_repetition, false) and
               not has_small_cave_repetition?(path) do
          true ->
            {:exploring, path ++ [next_step]}

          _ ->
            {:error, path}
        end

      true ->
        {:exploring, path ++ [next_step]}
    end
  end

  def has_small_cave_repetition?(path) do
    path
    |> Enum.filter(&String.match?(&1, ~r/^[[:lower:]]+$/))
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.any?(fn {_cave, repetitions} -> repetitions == 2 end)
  end

  def get_paths_map(data) do
    (data ++ map_two_way_paths(data))
    |> Enum.group_by(&List.first(&1))
    |> Map.to_list()
    |> Enum.map(fn {key, paths} ->
      {key,
       paths
       |> Enum.map(&Enum.at(&1, 1))
       |> Enum.uniq()}
    end)
    |> Enum.reject(&(elem(&1, 0) == "end"))
    |> Enum.into(%{})
  end

  def map_two_way_paths(data) do
    data
    |> Enum.map(fn [a, b] -> [b, a] end)
  end

  defp get_data(nil) do
    Api.get_input(12)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    data
    |> String.splitter("\n", trim: true)
    |> Enum.map(&(String.splitter(&1, "-", trim: true) |> Enum.take(2)))
  end

  defp get_data(_), do: []
end
