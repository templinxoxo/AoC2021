defmodule Day11Test do
  use ExUnit.Case
  doctest Day11
  alias Day11

  def test_data do
    """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
  end

  def test_data_sample do
    """
    11111
    19991
    19191
    19991
    11111
    """
  end

  test "Part 1 sample" do
    part1 =
      test_data_sample()
      |> Day11.part1(2)

    assert part1 == 9
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day11.part1(100)

    assert part1 == 1656
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day11.part2()

    assert part2 == 195
  end
end
