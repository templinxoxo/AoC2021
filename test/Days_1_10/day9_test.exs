defmodule Day9Test do
  use ExUnit.Case
  doctest Day9
  alias Day9

  def test_data do
    """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day9.part1()

    assert part1 == 15
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day9.part2()

    assert part2 == 1134
  end
end
