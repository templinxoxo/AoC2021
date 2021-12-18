defmodule Day18.Explode do
  import Day18.Parser

  def explode(data) when is_list(data) do
    indexed_data =
      data
      |> to_indexed_list()

    indexed_data
    |> Enum.find_index(&(length(elem(&1, 1)) > 4))
    |> case do
      nil ->
        data

      index ->
        indexed_data
        |> explode_index(index)
    end
  end

  def explode_index(data, index) do
    {x1, index_arr} = Enum.at(data, index)
    {x2, _} = Enum.at(data, index + 1)

    new_index_arr = index_arr |> List.delete_at(-1)
    new_value = {0, new_index_arr}

    data
    # replace exploding pair
    |> List.delete_at(index)
    |> List.replace_at(index, new_value)
    # add to prev
    |> add_at(index - 1, x1)
    # add to next
    |> add_at(index + 1, x2)
  end

  def add_at(data, index, value) do
    case index do
      -1 ->
        data

      index when index >= length(data) ->
        data

      index ->
        {old_value, index_arr} = Enum.at(data, index)
        new_value = {old_value + value, index_arr}

        List.replace_at(data, index, new_value)
    end
  end

  def will_explode?(data) when is_list(data) do
    data
    |> Enum.any?(&(length(elem(&1, 1)) > 4))
  end

  def will_explode?(_), do: false
end
