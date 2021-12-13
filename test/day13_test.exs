defmodule Day13Test do
  use ExUnit.Case
  doctest Day13
  alias Day13

  def test_data do
    """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day13.part1()

    assert part1 == 17
  end

  # test "Part 2" do
  #   part2 =
  #     test_data()
  #     |> Day13.part2()

  #   assert part2 == 5
  # end
end
