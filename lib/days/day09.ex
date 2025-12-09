defmodule Day09 do
  @moduledoc """
  Advent of Code - Day 09
  """
  defp calculate_rectangle_area({x1, y1}, {x2, y2}, memo) do
    if Map.has_key?(memo, MapSet.new([{x1, y1}, {x2, y2}])) do
      memo
    else

    width = abs(x2 - x1) + 1
    height = abs(y2 - y1) + 1

    area = width * height
    Map.put(memo, MapSet.new([{x1, y1}, {x2, y2}]), area)
    end

  end

  defp calculate_all_areas(coords) do
    Enum.reduce(coords, %{}, fn {x1, y1}, memo ->
      Enum.reduce(coords, memo, fn {x2, y2}, memo_acc ->
        if {x1, y1} != {x2, y2} do
          calculate_rectangle_area({x1, y1}, {x2, y2}, memo_acc)
        else
          memo_acc
        end
      end)
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part1(input) do
    input
    |> parse_input()
    |> calculate_all_areas()
    |> IO.inspect(label: "Calculated Areas")
    |> Map.values()
    |> Enum.max()
  end

  def part2(input) do
    red = parse_input(input)

    
  end
end
