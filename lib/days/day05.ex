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

  defp reduce_ranges(ranges) do
    reduced_ranges =
      ranges
      |> Enum.sort
      |> Enum.reduce([], fn {start, end_}, acc ->
        Enum.reduce(acc, %{reduced_ranges: acc, changed: false}, fn range, acc2 ->
          case range do
            {r_start, r_end} when start >= r_start and start <= r_end ->
              %{
                reduced_ranges: [
                  {min(start, r_start), max(end_, r_end)}
                  | Enum.filter(acc2.reduced_ranges, fn x -> x != range end)
                ],
                changed: true
              }

            _ ->
              acc2
          end
        end)
        |> case do
          %{reduced_ranges: new_ranges, changed: true} -> new_ranges
          %{reduced_ranges: new_ranges, changed: false} -> new_ranges ++ [{start, end_}]
        end
      end)

    if length(reduced_ranges) != length(ranges) do
      reduce_ranges(reduced_ranges)
    else
      reduced_ranges
    end
  end

  def part2(input) do
    %{ranges: ranges} = parse_input(input)

    reduce_ranges(ranges)
    |> Enum.map(fn {start, end_} -> end_ - start + 1 end)
    |> Enum.sum()
  end
end
