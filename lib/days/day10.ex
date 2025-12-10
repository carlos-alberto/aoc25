defmodule Day10 do
  @moduledoc """
  Advent of Code - Day 10
  """
  defp parse_buttons(button_strs) do
    button_strs
    |> Enum.map(fn s ->
      s
      |> String.slice(1..-2//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp parse_final(final_str) do
    final_str
    |> String.slice(1..-2//1)
    |> String.graphemes()
    |> Enum.map(&(&1 == "#"))
  end

  defp solve_line(line) do
    [end_str | button_strs] = String.split(line, " ")

    buttons = parse_buttons(Enum.drop(button_strs, -1))

    final = parse_final(end_str)

    init_state = Enum.map(final, fn _ -> false end)

    bfs(final, buttons, MapSet.new([init_state]), [{init_state, 0}])
  end

  defp bfs(final, _buttons, _visited, [{state, depth} | _]) when state == final do
    depth
  end

  defp bfs(final, buttons, visited, [{state, depth} | queue_tail]) do
    next_states =
      buttons
      |> Enum.map(fn button -> apply_button(state, button) end)
      |> Enum.reject(&MapSet.member?(visited, &1))

    new_visited =
      Enum.reduce(next_states, visited, fn s, acc -> MapSet.put(acc, s) end)

    new_queue =
      queue_tail ++ Enum.map(next_states, fn s -> {s, depth + 1} end)

    bfs(final, buttons, new_visited, new_queue)
  end

  defp apply_button(state, presses) do
    state
    |> Enum.with_index()
    |> Enum.map(fn {val, idx} -> if idx in presses, do: !val, else: val end)
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&solve_line/1)
    |> Enum.sum()
  end

  def part2(_input) do
    :nottodo
  end
end
