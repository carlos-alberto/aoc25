defmodule Day06 do
  @moduledoc """
  Advent of Code - Day 06
  """

  def part1(input) do
    %{data: data, operations: operations} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{data: %{}, operations: []}, fn line, acc ->
        if String.contains?(line, ["*", "+"]) do
          ops =
            line
            |> String.graphemes()
            |> Enum.filter(&(&1 in ["*", "+"]))

          %{acc | operations: ops}
        else
          nums =
            line
            |> String.split(~r/\s+/, trim: true)
            |> Enum.map(&String.to_integer/1)

          new_data =
            Enum.with_index(nums)
            |> Enum.reduce(acc.data, fn {num, idx}, data ->
              Map.update(data, idx, [num], fn existing -> existing ++ [num] end)
            end)

          %{acc | data: new_data}
        end
      end)

    operations
    |> Enum.with_index()
    |> Enum.reduce(0, fn {op, idx}, acc ->
      nums = Map.get(data, idx, [])

      case op do
        "*" -> Enum.product(nums) + acc
        "+" -> Enum.sum(nums) + acc
      end
    end)
  end

  def part2(input) do
    # TODO: Implement Part 2
    input
  end
end
