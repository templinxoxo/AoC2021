defmodule Day1Test do
  use ExUnit.Case
  doctest Day1
  alias Day1

  def test_data do
    """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day1.part1()

    assert part1 == 7
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day1.part2()

    assert part2 == 5
  end
end
