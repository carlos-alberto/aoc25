defmodule Day02 do
  @moduledoc """
  Advent of Code - Day 02
  """

  defp is_same_part_one(num) do
    str = Integer.to_string(num)
    half = div(byte_size(str), 2)

    {first, last} = String.split_at(str, half)
    first == last
  end

  defp parse_range(line) do
    [a, b] =
      line
      |> String.split("-", trim: true)
      |> Enum.map(&String.to_integer/1)

    a..b
  end

  def part1(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&parse_range/1)
    |> Enum.flat_map(& &1)
    |> Enum.filter(&is_same_part_one/1)
    |> Enum.sum()
  end

  defp is_same_part_two(num) do
    str = Integer.to_string(num)
    len = byte_size(str)

    if len < 2 do
      false
    else
      2..len
      |> Enum.filter(&(rem(len, &1) == 0))
      |> Enum.any?(fn parts ->
        chunk_size = div(len, parts)

        chunks =
          str
          |> String.codepoints()
          |> Enum.chunk_every(chunk_size)

        length(chunks) > 1 and Enum.uniq(chunks) |> length() == 1
      end)
    end
  end

  def part2(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&parse_range/1)
    |> Enum.flat_map(& &1)
    |> Enum.filter(&is_same_part_two/1)
    |> Enum.sum()
  end
end
