defmodule Day18.Processor do
  import Day18.Parser
  import Day18.Explode
  import Day18.Split

  def calculate(data) do
    [start | to_add] = data

    to_add
    |> Enum.reduce(start, fn elem, sum ->
      add(sum, elem)
    end)
  end

  def add(data, elem) do
    indexed_data =
      data
      |> to_indexed_list()
      |> Enum.map(fn {value, index_arr} ->
        {value, [0 | index_arr]}
      end)

    indexed_elem =
      elem
      |> to_indexed_list()
      |> Enum.map(fn {value, index_arr} ->
        {value, [1 | index_arr]}
      end)

    (indexed_data ++ indexed_elem)
    |> process()
  end

  def process(data) when is_list(data) do
    cond do
      will_explode?(data) ->
        data
        |> explode()
        |> process()

      will_split?(data) ->
        data
        |> split()
        |> process()

      true ->
        data
    end
  end
end
