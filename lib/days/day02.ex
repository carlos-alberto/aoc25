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

  defp is_same_part_two(num) do
    str = Integer.to_string(num)
    len = byte_size(str)

    if len < 2 do
      false
    else
      2..len
      |> Stream.filter(&(rem(len, &1) == 0))
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

  def part1(input) do
    input
    |> String.split(",", trim: true)
    |> Stream.map(&parse_range/1)
    |> Stream.flat_map(& &1)
    |> Stream.chunk_every(1000)
    |> Task.async_stream(
      fn chunk -> Enum.filter(chunk, &is_same_part_one/1) end,
      timeout: :infinity
    )
    |> Enum.reduce(0, fn
      {:ok, matching_numbers}, acc -> acc + Enum.sum(matching_numbers)
      {:error, _}, acc -> acc
    end)
  end

  def part2(input) do
    input
    |> String.split(",", trim: true)
    |> Stream.map(&parse_range/1)
    |> Stream.flat_map(& &1)
    |> Stream.chunk_every(1000)
    |> Task.async_stream(
      fn chunk -> Enum.filter(chunk, &is_same_part_two/1) end,
      timeout: :infinity
    )
    |> Enum.reduce(0, fn
      {:ok, matching_numbers}, acc -> acc + Enum.sum(matching_numbers)
      {:error, _}, acc -> acc
    end)
  end
end
