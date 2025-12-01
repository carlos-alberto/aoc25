defmodule Day01 do
  @moduledoc """
  Advent of Code - Day 01
  """

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{current: 50, zeroes: 0}, fn line, %{current: current, zeroes: zeroes} ->
      <<turn::binary-size(1), dist::binary>> = line
      distance = String.to_integer(dist)

      # Apply turn
      new_pos =
        case turn do
          "L" -> current - distance
          "R" -> current + distance
        end

      wrapped = Integer.mod(new_pos, 100)

      # Count zeroes
      new_zeroes = if wrapped == 0, do: zeroes + 1, else: zeroes

      %{
        current: wrapped,
        zeroes: new_zeroes
      }
    end)
    |> Map.get(:zeroes)
  end

  defp crosses_zero("R", current, dist) do
    first_k = if current == 0, do: 100, else: 100 - current

    if first_k > dist do
      0
    else
      1 + div(dist - first_k, 100)
    end
  end

  defp crosses_zero("L", current, dist) do
    first_k = if current == 0, do: 100, else: current

    if first_k > dist do
      0
    else
      1 + div(dist - first_k, 100)
    end
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{current: 50, zeroes: 0}, fn line, acc ->
      %{current: current, zeroes: zeroes} = acc
      <<turn::binary-size(1), dist::binary>> = line
      dist = String.to_integer(dist)

      hits = crosses_zero(turn, current, dist)

      new_pos =
        case turn do
          "L" -> current - dist
          "R" -> current + dist
        end
        |> Integer.mod(100)

      %{current: new_pos, zeroes: zeroes + hits}
    end)
    |> Map.get(:zeroes)
  end
end
