defmodule Day05 do
  @moduledoc """
  Advent of Code - Day 05
  """

  defp item_in_ranges(item, ranges) do
    Enum.any?(ranges, fn {start, end_} -> item >= start and item <= end_ end)
  end

  defp parse_input(input) do
    input
      |> String.split("\n")
      |> Enum.reduce(%{ranges: [], items: [], switched: false}, fn line, acc ->
        case line do
          "" ->
            %{acc | switched: true}

          _ ->
            if acc.switched do
              %{acc | items: acc.items ++ [String.to_integer(line)]}
            else
              [start_s, end_s] = String.split(line, "-")
              start = String.to_integer(start_s)
              end_ = String.to_integer(end_s)
              %{acc | ranges: [{start, end_} | acc.ranges]}
            end
        end
      end)
  end

  def part1(input) do
    %{ranges: ranges, items: items} = parse_input(input)

    items
    |> Enum.filter(fn item -> item_in_ranges(item, ranges) end)
    |> length()
  end

  def part2(input) do
    %{ranges: ranges} = parse_input(input)

    Enum.reduce(ranges, MapSet.new(), fn {start, end_}, acc ->
      Enum.reduce(start..end_, acc, fn item, acc2 -> MapSet.put(acc2, item) end)
    end)
    |> MapSet.size
  end
end
