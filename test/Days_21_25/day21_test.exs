defmodule Day21Test do
  use ExUnit.Case
  doctest Day21
  alias Day21

  def test_data do
    {4, 8}
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day21.part1()

    assert part1 == 739_785
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day21.Part2.part2()

    assert part2 == 444_356_092_776_315
  end
end
