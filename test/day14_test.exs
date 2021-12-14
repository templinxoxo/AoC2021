defmodule Day14Test do
  use ExUnit.Case
  doctest Day14
  alias Day14

  def test_data do
    """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day14.part1()

    assert part1 == 1588
  end

  test "Part 2" do
    part1 =
      test_data()
      |> Day14.part2()

    assert part1 == 2_188_189_693_529
  end
end
