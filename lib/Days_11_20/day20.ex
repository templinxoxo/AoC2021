defmodule Day20 do
  def part1(data \\ nil) do
    data
    |> get_data()
    |> enhance(2, preview: false)
    |> List.flatten()
    |> Enum.sum()
  end

  def part2(data \\ nil) do
    data
    |> get_data()
    |> enhance(50, preview: false)
    |> List.flatten()
    |> Enum.sum()
  end

  def enhance({enhancement_algorithm, init_data}, times, opts \\ [], infinite_border_value \\ 0) do
    data = add_border_pixels(init_data, infinite_border_value, 3)
    w = length(Enum.at(data, 0)) - 2
    h = length(data) - 2

    new_border_value = decode_enhanced_pixel(data, 1, 1, enhancement_algorithm)

    enhanced_data =
      1..h
      |> Enum.map(fn y ->
        1..w
        |> Enum.map(fn x ->
          decode_enhanced_pixel(data, x, y, enhancement_algorithm)
        end)
      end)
      |> remove_border_pixels(1)

    preview(enhanced_data, new_border_value, opts)

    if times > 1 do
      enhance({enhancement_algorithm, enhanced_data}, times - 1, opts, new_border_value)
    else
      enhanced_data
    end
  end

  def add_border_pixels(data, border, border_layers) do
    w = length(Enum.at(data, 0))
    horizontal_border = List.duplicate(border, w)

    vertical_border = List.duplicate(border, border_layers)

    List.duplicate(nil, border_layers)
    |> Enum.reduce(
      data,
      fn _, d ->
        d
        |> List.insert_at(0, horizontal_border)
        |> List.insert_at(-1, horizontal_border)
      end
    )
    |> Enum.map(&(vertical_border ++ &1 ++ vertical_border))
  end

  def remove_border_pixels(data, border_layers) when is_list(data) do
    data
    |> Enum.split(border_layers)
    |> elem(1)
    |> Enum.split(-border_layers)
    |> elem(0)
    |> Enum.map(&remove_border_pixels(&1, border_layers))
  end

  def remove_border_pixels(data, _), do: data

  def decode_enhanced_pixel(data, x0, y0, enhancement_algorithm) do
    index =
      (y0 - 1)..(y0 + 1)
      |> Enum.flat_map(fn y ->
        (x0 - 1)..(x0 + 1)
        |> Enum.map(fn x ->
          Helpers.value_at(data, x, y)
        end)
      end)
      |> Integer.undigits(2)

    Enum.at(enhancement_algorithm, index)
  end

  defp get_data(nil) do
    Api.get_input(20)
    |> get_data()
  end

  defp get_data(data) when is_binary(data) do
    [enhancement_algorithm_raw, data_raw] =
      data
      |> String.splitter("\n\n", trim: true)
      |> Enum.take(2)

    enhancement_algorithm =
      enhancement_algorithm_raw
      |> String.split("\n")
      |> Enum.join("")
      |> String.splitter("", trim: true)
      |> Enum.map(&to_int(&1))

    data =
      data_raw
      |> String.splitter("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.splitter("", trim: true)
        |> Enum.map(&to_int(&1))
      end)

    {enhancement_algorithm, data}
  end

  defp get_data(_), do: []

  defp to_int("."), do: 0
  defp to_int("#"), do: 1
  defp to_pixel(0), do: "."
  defp to_pixel(1), do: "#"

  defp preview(data, infinite_border_value, opts) do
    if Keyword.get(opts, :preview) do
      data
      |> add_border_pixels(infinite_border_value, 6)
      |> Enum.map(fn row ->
        row
        |> Enum.map(&to_pixel(&1))
        |> Enum.join(" ")
        |> IO.inspect()
      end)

      IO.inspect("")
    end
  end
end
