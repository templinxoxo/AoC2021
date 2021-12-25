defmodule Day25Test do
  use ExUnit.Case
  alias Day25
  doctest Day25

  def test_data() do
    """
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
    """
  end

  test "Part 1" do
    result = Day25.part1(test_data)

    assert result == 58
  end
end
