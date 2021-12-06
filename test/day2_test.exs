defmodule Day2Test do
  use ExUnit.Case
  doctest Day2
  alias Day2

  def test_data do
    """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day2.part1()

    assert part1 == 150
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day2.part2()

    assert part2 == 900
  end
end
