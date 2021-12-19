defmodule Day10Test do
  use ExUnit.Case
  doctest Day10
  alias Day10

  def test_data do
    """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """
  end

  test "Part 1" do
    part1 =
      test_data()
      |> Day10.part1()

    assert part1 == 26397
  end

  test "Part 2" do
    part2 =
      test_data()
      |> Day10.part2()

    assert part2 == 288_957
  end
end
