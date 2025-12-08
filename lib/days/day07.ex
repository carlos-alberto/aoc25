defmodule Day07 do
  @moduledoc """
  Advent of Code - Day 07
  """
  defp process_rows([], _row_idx, acc), do: acc

  defp process_rows([line | rest_lines], row_idx, acc) do
    updated_acc =
      line
      |> String.graphemes()
      |> process_cols(row_idx, 0, acc)

    process_rows(rest_lines, row_idx + 1, updated_acc)
  end

  defp process_cols([], _row_idx, _col_idx, acc), do: acc

  defp process_cols([char | rest_chars], row_idx, col_idx, acc) do
    process_cols(rest_chars, row_idx, col_idx + 1, handle_cell(char, row_idx, col_idx, acc))
  end

  defp handle_cell("S", row_idx, col_idx, acc) do
    %{acc | current_beams: Map.put(acc.current_beams, {row_idx, col_idx}, true)}
  end

  defp handle_cell("^", row_idx, col_idx, acc) do
    has_beam_above? =
      Enum.any?(0..row_idx, fn r ->
        Map.has_key?(acc.current_beams, {r, col_idx})
      end)

    if has_beam_above? do
      new_beams =
        acc.current_beams
        |> Map.put({row_idx, col_idx - 1}, true)
        |> Map.put({row_idx, col_idx + 1}, true)
        |> Map.filter(fn {{_r, c}, _v} -> c != col_idx end)

      %{acc | current_beams: new_beams, splits: acc.splits + 1}
    else
      acc
    end
  end

  defp handle_cell(_char, _row_idx, _col_idx, acc), do: acc

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> process_rows(0, %{current_beams: %{}, splits: 0})
    |> Map.get(:splits)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)

    10
  end
end
