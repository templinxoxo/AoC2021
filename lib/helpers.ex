defmodule Helpers do
  def multiply(data) do
    data
    |> Enum.reduce(1, fn value, acc -> acc * value end)
  end

  def transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
  end

  def points_in_between(a1, a2) do
    positive = a1 < a2

    if positive do
      a1..a2
    else
      a2..a1
    end
  end

  def value_at(matrix, x, y) do
    matrix
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def matrix_map(matrix, callback) do
    matrix
    |> Enum.map(fn row ->
      row
      |> Enum.map(&callback.(&1))
    end)
  end

  def matrix_map_with_index(matrix, callback) do
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {point, x} ->
        callback.(point, {x, y})
      end)
    end)
  end

  def insert_at(matrix, x, y, value) do
    new_row = insert_at(matrix |> Enum.at(y), x, value)
    insert_at(matrix, y, new_row)
  end

  def insert_at(row, x, value) do
    {head, rest} = Enum.split(row, x)
    {_, tail} = Enum.split(rest, 1)
    head ++ [value] ++ tail
  end
end
