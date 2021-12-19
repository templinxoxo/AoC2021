defmodule Day6Test do
  use ExUnit.Case
  doctest Day6
  alias Day6

  def test_data do
    """
    3,4,3,1,2
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day6.part1()

    assert part1 == 5934
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day6.part2()

    assert part2 == 26_984_457_539
  end
end
