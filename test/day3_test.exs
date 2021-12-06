defmodule Day3Test do
  use ExUnit.Case
  doctest Day3
  alias Day3

  def test_data do
    """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day3.part1()

    assert part1 == 198
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day3.part2()

    assert part2 == 230
  end
end
