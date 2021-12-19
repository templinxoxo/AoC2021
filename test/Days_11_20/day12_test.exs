defmodule Day12Test do
  use ExUnit.Case
  doctest Day12
  alias Day12

  test "Part 1 1" do
    part1 =
      test_1_data()
      |> Day12.part1()

    assert part1 == 10
  end

  test "Part 1 2" do
    part1 =
      test_2_data()
      |> Day12.part1()

    assert part1 == 19
  end

  test "Part 1 3" do
    part1 =
      test_3_data()
      |> Day12.part1()

    assert part1 == 226
  end

  test "Part 2 1" do
    part2 =
      test_1_data()
      |> Day12.part2()

    assert part2 == 36
  end

  test "Part 2 2" do
    part2 =
      test_2_data()
      |> Day12.part2()

    assert part2 == 103
  end

  test "Part 2 3" do
    part2 =
      test_3_data()
      |> Day12.part2()

    assert part2 == 3509
  end

  def test_1_data do
    """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """
  end

  def test_2_data do
    """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """
  end

  def test_3_data do
    """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """
  end
end
