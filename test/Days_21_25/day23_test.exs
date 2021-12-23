defmodule Day23Test do
  use ExUnit.Case
  import Day23
  doctest Day23

  def data_1() do
    """
    #...........#
    ###D#D#C#C###
      #B#A#B#A#
    """
  end

  test "Part 1" do
    {_, result} =
      data_1()
      |> parse_data()
      |> move(7, 1, 8, 0)
      |> move(7, 2, 4, 0)
      |> move(8, 0, 7, 2)
      |> move(9, 1, 8, 0)
      |> move(8, 0, 7, 1)
      |> move(9, 2, 11, 0)
      |> move(5, 1, 6, 0)
      |> move(6, 0, 9, 2)
      |> move(5, 2, 10, 0)
      |> move(4, 0, 5, 2)
      |> move(3, 1, 8, 0)
      |> move(8, 0, 9, 1)
      |> move(3, 2, 4, 0)
      |> move(4, 0, 5, 1)
      |> move(10, 0, 3, 2)
      |> move(11, 0, 3, 1)

    assert result == 16059
  end

  def data_2() do
    """
    #...........#
    ###D#D#C#C###
      #D#C#B#A#
      #D#B#A#C#
      #B#A#B#A#
    """
  end

  test "Part 2" do
    {_, result} =
      data_2()
      |> parse_data()
      |> move(9, 1, 11, 0)
      |> move(9, 2, 1, 0)
      |> move(9, 3, 10, 0)
      |> move(9, 4, 2, 0)
      |> move(3, 1, 8, 0)
      |> move(8, 0, 9, 4)
      |> move(3, 2, 8, 0)
      |> move(8, 0, 9, 3)
      |> move(3, 3, 8, 0)
      |> move(8, 0, 9, 2)
      |> move(5, 1, 8, 0)
      |> move(8, 0, 9, 1)
      |> move(3, 4, 8, 0)
      |> move(2, 0, 3, 4)
      |> move(1, 0, 3, 3)
      |> move(5, 2, 2, 0)
      |> move(5, 3, 6, 0)
      |> move(5, 4, 4, 0)
      |> move(4, 0, 3, 2)
      |> move(6, 0, 5, 4)
      |> move(8, 0, 5, 3)
      |> move(7, 1, 8, 0)
      |> move(7, 2, 6, 0)
      |> move(6, 0, 5, 2)
      |> move(7, 3, 4, 0)
      |> move(4, 0, 3, 1)
      |> move(7, 4, 6, 0)
      |> move(6, 0, 5, 1)
      |> move(2, 0, 7, 4)
      |> move(8, 0, 7, 3)
      |> move(10, 0, 7, 2)
      |> move(11, 0, 7, 1)

    assert result == 43117
  end

  def test_data_1() do
    """
    #...........#
    ###B#C#B#D###
      #A#D#C#A#
    """
  end

  test "Part 1 test" do
    {_, result} =
      test_data_1()
      |> parse_data()
      |> move(7, 1, 4, 0)
      |> move(5, 1, 6, 0)
      |> move(6, 0, 7, 1)
      |> move(5, 2, 6, 0)
      |> move(4, 0, 5, 2)
      |> move(9, 1, 8, 0)
      |> move(9, 2, 10, 0)
      |> move(8, 0, 9, 2)
      |> move(6, 0, 9, 1)
      |> move(3, 1, 4, 0)
      |> move(4, 0, 5, 1)
      |> move(10, 0, 3, 1)

    assert result == 12521
  end

  def test_data_2() do
    """
    #...........#
    ###B#C#B#D###
      #D#C#B#A#
      #D#B#A#C#
      #A#D#C#A#
    """
  end

  test "Part 2 test" do
    {_, result} =
      test_data_2()
      |> parse_data()
      |> move(9, 1, 11, 0)
      |> move(9, 2, 1, 0)
      |> move(7, 1, 10, 0)
      |> move(7, 2, 8, 0)
      |> move(7, 3, 2, 0)
      |> move(5, 1, 6, 0)
      |> move(6, 0, 7, 3)
      |> move(5, 2, 6, 0)
      |> move(6, 0, 7, 2)
      |> move(5, 3, 6, 0)
      |> move(5, 4, 4, 0)
      |> move(6, 0, 5, 4)
      |> move(8, 0, 5, 3)
      |> move(10, 0, 5, 2)
      |> move(9, 3, 8, 0)
      |> move(8, 0, 7, 1)
      |> move(9, 4, 10, 0)
      |> move(4, 0, 9, 4)
      |> move(3, 1, 4, 0)
      |> move(4, 0, 5, 1)
      |> move(3, 2, 8, 0)
      |> move(3, 3, 6, 0)
      |> move(8, 0, 9, 3)
      |> move(6, 0, 9, 2)
      |> move(2, 0, 3, 3)
      |> move(1, 0, 3, 2)
      |> move(10, 0, 3, 1)
      |> move(11, 0, 9, 1)

    assert result == 44169
  end
end
