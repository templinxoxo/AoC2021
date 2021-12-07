defmodule Day5Test do
  use ExUnit.Case
  doctest Day5
  alias Day5

  def test_data do
    """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day5.part1()

    assert part1 == 5
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day5.part2()

    assert part2 == 12
  end
end
