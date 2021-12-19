defmodule Day7Test do
  use ExUnit.Case
  doctest Day7
  alias Day7

  def test_data do
    """
    16,1,2,0,4,2,7,1,2,14
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day7.part1()

    assert part1 == 37
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day7.part2()

    assert part2 == 168
  end
end
