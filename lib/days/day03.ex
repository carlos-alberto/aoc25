defmodule Day03 do
  @moduledoc """
  Advent of Code - Day 03
  """

  defp toInt(int, index, length) do
    case length - index - 1 do
      0 -> int
      _ -> 10 ** (length - index - 1) * int
    end
  end

  defp getMax(line, count) do
    line
      |> String.split("", trim: true)
      |> Stream.map(&String.to_integer/1)
      |> Stream.chunk_every(count, 1, :discard)
      |> Enum.reduce(List.duplicate(-1, 2), fn ints , acc ->
        Enum.reduce(Enum.with_index(ints), acc, fn {num, idx}, acc2 ->
          if num > Enum.at(acc2, idx) do
            {left, _} = Enum.split(acc2, idx)
            {_, right} = Enum.split(ints, idx + 1)
            left ++ [num] ++ right
          else
            acc2
          end
        end)
      end)
      |> Enum.with_index()
      |> Enum.map(fn {v, i} -> toInt(v, i, count) end)
      |> Enum.sum()
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&getMax(&1, 2))
    |> Enum.sum
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&getMax(&1, 12))
    |> Enum.sum
  end
end
