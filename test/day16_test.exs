defmodule Day16Test do
  use ExUnit.Case
  doctest Day16
  alias Day16

  test "Part 1 - decode 1" do
    code = Day16.Decoder.decode("D2FE28") |> Day16.Decoder.flatten()

    assert code == [{6, 4, 2021}]
  end

  test "Part 1 - decode 2" do
    [{version, type, _}, {_, _, val1}, {_, _, val2}] =
      Day16.Decoder.decode("38006F45291200") |> Day16.Decoder.flatten()

    assert version == 1
    assert type == 6
    assert val1 == 10
    assert val2 == 20
  end

  test "Part 1 - decode 3" do
    [{version, type, _}, {_, _, val1}, {_, _, val2}, {_, _, val3}] =
      Day16.Decoder.decode("EE00D40C823060") |> Day16.Decoder.flatten()

    assert version == 7
    assert type == 3
    assert val1 == 1
    assert val2 == 2
    assert val3 == 3
  end

  test "Part 1 - sum 1" do
    code = Day16.part1("8A004A801A8002F478")

    assert code == 16
  end

  test "Part 1 - sum 2" do
    code = Day16.part1("620080001611562C8802118E34")

    assert code == 12
  end

  test "Part 1 - sum 3" do
    code = Day16.part1("C0015000016115A2E0802F182340")

    assert code == 23
  end

  test "Part 1 - sum 4" do
    code = Day16.part1("A0016C880162017C3686B18A3D4780")

    assert code == 31
  end

  test "Part 2 - sum 1" do
    result = Day16.part2("C200B40A82")

    assert result == 3
  end

  test "Part 2 - sum 2" do
    result = Day16.part2("04005AC33890")

    assert result == 54
  end

  test "Part 2 - sum 3" do
    result = Day16.part2("880086C3E88112")

    assert result == 7
  end

  test "Part 2 - sum 4" do
    result = Day16.part2("CE00C43D881120")

    assert result == 9
  end

  test "Part 2 - sum 5" do
    result = Day16.part2("D8005AC2A8F0")

    assert result == 1
  end

  test "Part 2 - sum 6" do
    result = Day16.part2("F600BC2D8F")

    assert result == 0
  end

  test "Part 2 - sum 7" do
    result = Day16.part2("9C005AC2F8F0")

    assert result == 0
  end

  test "Part 2 - sum 8" do
    result = Day16.part2("9C0141080250320F1802104A08")

    assert result == 1
  end
end
