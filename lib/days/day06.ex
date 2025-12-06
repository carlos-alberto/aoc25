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

  defp to_number(chunk) do
    chunk
    |> Enum.join()
    |> String.trim()
    |> String.to_integer()
  end

  defp ensure_length(list, idx) do
    needed = idx - length(list) + 1

    if needed > 0 do
      list ++ List.duplicate([], needed)
    else
      list
    end
  end

  def part2(input) do
    %{data: data, operations: operations} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{data: [], operations: []}, fn line, acc ->
        if String.contains?(line, ["*", "+"]) do
          ops =
            line
            |> String.graphemes()
            |> Enum.filter(&(&1 in ["*", "+"]))

          %{acc | operations: ops}
        else
          new_data =
            line
            |> String.graphemes()
            |> Enum.with_index()
            |> Enum.reduce(acc.data, fn {char, idx}, data ->
              data
              |> ensure_length(idx)
              |> List.update_at(idx, fn existing ->
                existing ++ [char]
              end)
            end)

          %{acc | data: new_data}
        end
      end)

    chunks =
      data
      |> Stream.chunk_by(fn chars -> Enum.all?(chars, &(&1 == " ")) end)
      |> Stream.filter(fn chunk ->
        not Enum.all?(chunk, fn chars -> Enum.all?(chars, &(&1 == " ")) end)
      end)

    operations
    |> Enum.with_index()
    |> Enum.reduce(0, fn {op, idx}, acc ->
      numbers =
        Enum.at(chunks, idx)
        |> Enum.map(&to_number/1)

      case op do
        "*" -> Enum.product(numbers) + acc
        "+" -> Enum.sum(numbers) + acc
      end
    end)
  end
end
