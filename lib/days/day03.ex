defmodule Day03 do
  @moduledoc """
  Advent of Code - Day 03
  """

  defp getMax(line) do
    result = 
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(%{first: -1, second: -1}, fn [a, b], %{first: first, second: second} ->
        cond do
          a > first ->
            %{first: a, second: b}
          b > second ->
            %{first: first, second: b}
          true ->
            %{first: first, second: second}
        end
      end)
    
    result.first * 10 + result.second
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&getMax/1)
    |> Enum.sum
  end

  def part2(input) do
    # TODO: Implement Part 2
    input
  end
end
