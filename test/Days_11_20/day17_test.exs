defmodule Day17Test do
  use ExUnit.Case
  doctest Day17
  alias Day17

  def test_data do
    [{20, 30}, {-5, -10}]
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day17.part1()

    assert part1 == 45
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day17.part2()

    assert part2 == 112
  end
end
