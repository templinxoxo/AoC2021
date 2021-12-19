defmodule Day16.Decoder do
  def decode(code) when is_binary(code) do
    code
    |> to_decimal()
    |> decode()
    |> Enum.at(0)
  end

  def decode(code) do
    if Enum.count(code) >= 11 do
      code
      |> decode_type_version()
      |> decode_by_type()
    else
      []
    end
  end

  def to_decimal(code) do
    code
    |> String.split("")
    |> Enum.map(&hex_to_bin_map(&1))
    |> Enum.flat_map(&String.splitter(&1, "", trim: true))
  end

  def decode_type_version(code) do
    {version, code} = decode_chars(code, 3)
    {type, code} = decode_chars(code, 3)

    {version, type, code}
  end

  def decode_chars(code, n) do
    {code, rest} = Enum.split(code, n)

    decoded =
      code
      |> Enum.map(&String.to_integer(&1))
      |> Integer.undigits(2)

    {decoded, rest}
  end

  def decode_chars(code) do
    {code, []} = decode_chars(code, length(code))
    code
  end

  def decode_by_type({version, type, code}) do
    case type do
      4 ->
        decode_literal({version, type}, code)

      _ ->
        decode_operator({version, type}, code)
    end
  end

  def decode_literal({version, type}, code) do
    # {:finished, code, tail}
    {_, code, tail} =
      code
      |> Enum.chunk_every(5)
      |> Enum.reduce({:decoding, [], []}, fn code_part, {status, numbers, tail} ->
        case status do
          :finished ->
            {:finished, numbers, tail ++ code_part}

          :decoding ->
            [prefix | chars] = code_part
            status = if prefix == "1", do: :decoding, else: :finished

            {status, numbers ++ chars, []}
        end
      end)

    [{version, type, decode_chars(code)} | decode(tail)]
  end

  def decode_operator({version, type}, ["0" | code]) do
    {sub_packet_size, sub_packet_bits} = Enum.split(code, 15)
    sub_packet_size = decode_chars(sub_packet_size)

    {sub_packet_bits, rest_bits} = sub_packet_bits |> Enum.split(sub_packet_size)

    [{version, type, decode(sub_packet_bits)} | decode(rest_bits)]
  end

  def decode_operator({version, type}, ["1" | code]) do
    {sub_packet_count, sub_packet_bits} = Enum.split(code, 11)
    sub_packet_count = decode_chars(sub_packet_count)

    {sub_packets, rest} =
      decode(sub_packet_bits)
      |> Enum.split(sub_packet_count)

    [{version, type, sub_packets} | rest]
  end

  def flatten(data) when is_list(data) do
    data
    |> Enum.flat_map(&flatten(&1))
  end

  def flatten({v, t, data}) when is_list(data) do
    [{v, t, nil}] ++ flatten(data)
  end

  def flatten(c), do: [c]

  defp hex_to_bin_map(char) do
    %{
      "0" => "0000",
      "1" => "0001",
      "2" => "0010",
      "3" => "0011",
      "4" => "0100",
      "5" => "0101",
      "6" => "0110",
      "7" => "0111",
      "8" => "1000",
      "9" => "1001",
      "A" => "1010",
      "B" => "1011",
      "C" => "1100",
      "D" => "1101",
      "E" => "1110",
      "F" => "1111"
    }
    |> Map.get(char, "")
  end
end
