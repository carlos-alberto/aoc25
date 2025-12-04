defmodule Day04 do
  @moduledoc """
  Advent of Code - Day 04
  """

  @surrounds [
    {-1, -1}, {-1, 0}, {-1, 1},
    {0, -1},           {0, 1},
    {1, -1},  {1, 0},  {1, 1}
  ]

  defp num_surrounded_by(x, y, mapped) do
    Enum.count(@surrounds, fn {dx, dy} -> Map.has_key?(mapped, {x + dx, y + dy}) end)
  end

  defp get_surrounds(mapped) do
    Map.keys(mapped)
    |> Enum.filter(fn {x, y} -> num_surrounded_by(x, y, mapped) < 4 end)
  end

  defp parse_input(input) do
    input
      |> String.split("\n", trim: true)
      |> Stream.with_index
      |> Enum.reduce(%{}, fn {line, line_idx}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, idx}, acc2 ->
          case char do
            "@" -> Map.put(acc2, {idx, line_idx}, true)
            _ -> acc2
          end
        end)
      end)
  end

  def part1(input) do
    input
    |> parse_input
    |> get_surrounds
    |> length()
  end

  defp get_and_remove_surrounds(mapped) do
    get_and_remove_surrounds(mapped, 0)
  end

  defp get_and_remove_surrounds(mapped, count) do
    surrounds = get_surrounds(mapped)

    case surrounds do
      [] ->
        count

      keys_to_remove ->
        get_and_remove_surrounds(
          Map.drop(mapped, keys_to_remove),
          count + length(keys_to_remove)
        )
    end
  end

  def part2(input) do
    input
    |> parse_input
    |> get_and_remove_surrounds
  end
end
