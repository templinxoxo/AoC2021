defmodule Day18.Parser do
  #
  # to_indexed_list(data)
  # from_indexed_list(data)
  #   map nested structure into 1 level list
  #   add (remove) list of original indexes of all list elem
  #   this is to help navigation back and forth between lists
  #
  def to_indexed_list(data, index_arr \\ [])

  def to_indexed_list(data, index_arr) when is_list(data) do
    if is_indexed_list?(data) do
      data
    else
      data
      |> Enum.with_index()
      |> Enum.map(fn {elem, index} ->
        to_indexed_list(elem, index_arr ++ [index])
      end)
      |> List.flatten()
    end
  end

  def to_indexed_list(data, index_arr) do
    {data, index_arr}
  end

  def from_indexed_list(data \\ [])

  def from_indexed_list(data) when is_list(data) do
    if is_indexed_list?(data) do
      data
      |> Enum.map(fn {value, [index | index_arr]} ->
        {value, index_arr, index}
      end)
      |> Enum.group_by(&elem(&1, 2))
      |> Enum.to_list()
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.map(fn {_, values} ->
        values
        |> Enum.map(fn {value, index_arr, _} ->
          case index_arr do
            [] -> value
            index_arr -> {value, index_arr}
          end
        end)
        |> from_indexed_list()
        |> remove_one_elem_list()
      end)
    else
      data
    end
  end

  def from_indexed_list({elem, _index_arr}), do: elem

  def remove_one_elem_list([x]), do: x
  def remove_one_elem_list(x), do: x

  def is_indexed_list?(data) when is_list(data) do
    data
    |> Enum.all?(
      &(is_tuple(&1) and
          not is_list(elem(&1, 0)) and
          is_list(elem(&1, 1)))
    )
  end

  def is_indexed_list?(_), do: false
end
