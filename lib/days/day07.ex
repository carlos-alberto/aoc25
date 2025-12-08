defmodule Day07 do
  @moduledoc """
  Advent of Code - Day 07
  """

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{current_beams: %{}, splits: 0}, fn {line, row_idx}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col_idx}, inner_acc ->
        case char do
          "S" ->
            %{
              inner_acc
              | current_beams: Map.put(inner_acc.current_beams, {row_idx, col_idx}, true)
            }

          "^" ->
            has_key =
              Enum.any?(0..row_idx, fn r ->
                Map.has_key?(inner_acc.current_beams, {r, col_idx})
              end)

            if has_key do
              %{
                current_beams:
                  inner_acc.current_beams
                  |> Map.put({row_idx, col_idx - 1}, true)
                  |> Map.put({row_idx, col_idx + 1}, true)
                  |> Map.filter(fn {{_r, c}, _v} -> c != col_idx end),
                splits: inner_acc.splits + 1
              }
            else
              inner_acc
            end

          _ ->
            inner_acc
        end
      end)
    end)
    |> Map.get(:splits)
  end

  def part2(input) do
    # TODO: Implement Part 2
    input

    10
  end
end
