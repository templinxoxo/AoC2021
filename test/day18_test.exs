defmodule Day18Test do
  use ExUnit.Case
  doctest Day18
  alias Day18

  import Day18.Magnitude
  import Day18.Parser
  import Day18.Processor

  def test_data do
    [
      [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
      [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
      [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
      [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
      [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
      [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
      [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
      [[9, 3], [[9, 9], [6, [4, 9]]]],
      [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
      [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]]
    ]
  end

  def parse_and_process(data) do
    data
    |> to_indexed_list()
    |> process()
    |> from_indexed_list()
  end

  test "simple addition" do
    a = [1, 2]
    b = [[3, 4], 5]

    result = add(a, b) |> from_indexed_list()

    assert result == [[1, 2], [[3, 4], 5]]
  end

  test "simple explosion - 1" do
    data = [[[[[9, 8], 1], 2], 3], 4]

    result = data |> parse_and_process()

    assert result == [[[[0, 9], 2], 3], 4]
  end

  test "simple explosion - 2" do
    data = [7, [6, [5, [4, [3, 2]]]]]

    result = data |> parse_and_process()

    assert result == [7, [6, [5, [7, 0]]]]
  end

  test "simple explosion - 3" do
    data = [[6, [5, [4, [3, 2]]]], 1]

    result = data |> parse_and_process()

    assert result == [[6, [5, [7, 0]]], 3]
  end

  test "simple explosion - 4" do
    data = [[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]]

    result = data |> parse_and_process()

    assert result == [[3, [2, [8, 0]]], [9, [5, [7, 0]]]]
  end

  test "simple splitting" do
    data = [3, [0, 11], [3, 10]]

    result = data |> parse_and_process()

    assert result == [3, [0, [5, 6]], [3, [5, 5]]]
  end

  test "addition and processing" do
    a = [[[[4, 3], 4], 4], [7, [[8, 4], 9]]]
    b = [1, 1]

    result = add(a, b) |> from_indexed_list()

    assert result == [[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]
  end

  test "processing - 1" do
    data = [
      [1, 1],
      [2, 2],
      [3, 3],
      [4, 4]
    ]

    result = calculate(data) |> from_indexed_list()

    assert result == [[[[1, 1], [2, 2]], [3, 3]], [4, 4]]
  end

  test "processing - 3" do
    data = [
      [1, 1],
      [2, 2],
      [3, 3],
      [4, 4],
      [5, 5]
    ]

    result = calculate(data) |> from_indexed_list()

    assert result == [[[[3, 0], [5, 3]], [4, 4]], [5, 5]]
  end

  test "processing - 4" do
    data = [
      [1, 1],
      [2, 2],
      [3, 3],
      [4, 4],
      [5, 5],
      [6, 6]
    ]

    result = calculate(data) |> from_indexed_list()

    assert result == [[[[5, 0], [7, 4]], [5, 5]], [6, 6]]
  end

  test "complex addition and processing 1" do
    a = [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]]
    b = [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]]

    expected = [[[[4, 0], [5, 4]], [[7, 7], [6, 0]]], [[8, [7, 7]], [[7, 9], [5, 0]]]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 2" do
    a = [[[[4, 0], [5, 4]], [[7, 7], [6, 0]]], [[8, [7, 7]], [[7, 9], [5, 0]]]]
    b = [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]]

    expected = [[[[6, 7], [6, 7]], [[7, 7], [0, 7]]], [[[8, 7], [7, 7]], [[8, 8], [8, 0]]]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 3" do
    a = [[[[6, 7], [6, 7]], [[7, 7], [0, 7]]], [[[8, 7], [7, 7]], [[8, 8], [8, 0]]]]
    b = [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]]

    expected = [[[[7, 0], [7, 7]], [[7, 7], [7, 8]]], [[[7, 7], [8, 8]], [[7, 7], [8, 7]]]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 4" do
    a = [[[[7, 0], [7, 7]], [[7, 7], [7, 8]]], [[[7, 7], [8, 8]], [[7, 7], [8, 7]]]]
    b = [7, [5, [[3, 8], [1, 4]]]]

    expected = [[[[7, 7], [7, 8]], [[9, 5], [8, 7]]], [[[6, 8], [0, 8]], [[9, 9], [9, 0]]]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 5" do
    a = [[[[7, 7], [7, 8]], [[9, 5], [8, 7]]], [[[6, 8], [0, 8]], [[9, 9], [9, 0]]]]
    b = [[2, [2, 2]], [8, [8, 1]]]

    expected = [[[[6, 6], [6, 6]], [[6, 0], [6, 7]]], [[[7, 7], [8, 9]], [8, [8, 1]]]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 6" do
    a = [[[[6, 6], [6, 6]], [[6, 0], [6, 7]]], [[[7, 7], [8, 9]], [8, [8, 1]]]]
    b = [2, 9]

    expected = [[[[6, 6], [7, 7]], [[0, 7], [7, 7]]], [[[5, 5], [5, 6]], 9]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 7" do
    a = [[[[6, 6], [7, 7]], [[0, 7], [7, 7]]], [[[5, 5], [5, 6]], 9]]
    b = [1, [[[9, 3], 9], [[9, 0], [0, 7]]]]

    expected = [[[[7, 8], [6, 7]], [[6, 8], [0, 8]]], [[[7, 7], [5, 0]], [[5, 5], [5, 6]]]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 8" do
    a = [[[[7, 8], [6, 7]], [[6, 8], [0, 8]]], [[[7, 7], [5, 0]], [[5, 5], [5, 6]]]]
    b = [[[5, [7, 4]], 7], 1]

    expected = [[[[7, 7], [7, 7]], [[8, 7], [8, 7]]], [[[7, 0], [7, 7]], 9]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "complex addition and processing 9" do
    a = [[[[7, 7], [7, 7]], [[8, 7], [8, 7]]], [[[7, 0], [7, 7]], 9]]
    b = [[[[4, 2], 2], 6], [8, 7]]

    expected = [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]
    result = add(a, b) |> from_indexed_list()

    assert expected == result
  end

  test "processing - 6" do
    data = [
      [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
      [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]],
      [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]],
      [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]],
      [7, [5, [[3, 8], [1, 4]]]],
      [[2, [2, 2]], [8, [8, 1]]],
      [2, 9],
      [1, [[[9, 3], 9], [[9, 0], [0, 7]]]],
      [[[5, [7, 4]], 7], 1],
      [[[[4, 2], 2], 6], [8, 7]]
    ]

    result = calculate(data) |> from_indexed_list()

    assert result == [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]
  end

  test "magnitude - 1" do
    data = [[1, 2], [[3, 4], 5]]
    expected = 143
    result = magnitude(data)
    assert result == expected
  end

  test "magnitude - 2" do
    data = [[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]
    expected = 1384
    result = magnitude(data)
    assert result == expected
  end

  test "magnitude - 3" do
    data = [[[[1, 1], [2, 2]], [3, 3]], [4, 4]]
    expected = 445
    result = magnitude(data)
    assert result == expected
  end

  test "magnitude - 4" do
    data = [[[[3, 0], [5, 3]], [4, 4]], [5, 5]]
    expected = 791
    result = magnitude(data)
    assert result == expected
  end

  test "magnitude - 5" do
    data = [[[[5, 0], [7, 4]], [5, 5]], [6, 6]]
    expected = 1137
    result = magnitude(data)
    assert result == expected
  end

  test "magnitude - 6" do
    data = [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]
    expected = 3488
    result = magnitude(data)
    assert result == expected
  end

  test "Part 1 - magnitude" do
    data = [[[[6, 6], [7, 6]], [[7, 7], [7, 0]]], [[[7, 7], [7, 7]], [[7, 8], [9, 9]]]]
    expected = 4140
    result = magnitude(data)

    assert result == expected
  end

  test "Part 1 - process" do
    data = test_data()

    expected = [[[[6, 6], [7, 6]], [[7, 7], [7, 0]]], [[[7, 7], [7, 7]], [[7, 8], [9, 9]]]]
    result = calculate(data) |> from_indexed_list()

    assert result == expected
  end

  test "Part 1" do
    data = test_data()

    expected = 4140
    result = Day18.part1(data)

    assert result == expected
  end

  test "Part 2" do
    data = test_data()

    expected = 3993
    result = Day18.part2(data)

    assert result == expected
  end
end
