defmodule Day18.Split do
  import Day18.Parser

  def split(data) when is_list(data) do
    indexed_data =
      data
      |> to_indexed_list()

    indexed_data
    |> Enum.find_index(&(elem(&1, 0) > 9))
    |> case do
      nil ->
        data

      index ->
        {x, index_arr} = Enum.at(indexed_data, index)

        new_value = [
          {floor(x / 2), index_arr ++ [0]},
          {ceil(x / 2), index_arr ++ [1]}
        ]

        indexed_data
        |> List.replace_at(index, new_value)
        |> List.flatten()
    end
  end

  def will_split?(data) when is_list(data) do
    data
    |> Enum.any?(&(elem(&1, 0) > 9))
  end

  def will_split?(_), do: false
end
