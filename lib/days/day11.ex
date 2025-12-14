defmodule Day11 do
  @moduledoc """
  Advent of Code - Day 11
  """

  defp dfs(graph, node, target, visited \\ MapSet.new(), path_count \\ 0) do
    if node == target do
      path_count + 1
    else
      visited = MapSet.put(visited, node)

      neighbours =
        Enum.filter(Map.get(graph, node, []), &(not MapSet.member?(visited, &1)))

      Enum.reduce(neighbours, path_count, fn neighbour, acc ->
        dfs(graph, neighbour, target, visited, acc)
      end)
    end
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      # aaa: you hhh
      [first, second] = String.split(line, ":", trim: true)
      # split second by spaces
      words = String.split(second, " ", trim: true)
      Map.put(acc, first, words)
    end)
  end

  def part1(input) do
    input
    |> parse_input()
    |> dfs("you", "out")
  end

  defp count_paths(graph, node, target, seen_dac, seen_fft, memo \\ %{}) do
    key = {node, seen_dac, seen_fft}

    case memo do
      %{^key => count} ->
        {count, memo}

      _ ->
        seen_dac = seen_dac or node == "dac"
        seen_fft = seen_fft or node == "fft"

        {result, memo} =
          if node == target do
            {if(seen_dac and seen_fft, do: 1, else: 0), memo}
          else
            Map.get(graph, node, [])
            |> Enum.reduce({0, memo}, fn neighbour, {acc, memo_acc} ->
              {count, memo_acc} =
                count_paths(graph, neighbour, target, seen_dac, seen_fft, memo_acc)

              {acc + count, memo_acc}
            end)
          end

        {result, Map.put(memo, key, result)}
    end
  end

  def part2(input) do
    input
    |> parse_input()
    |> count_paths("svr", "out", false, false)
    |> elem(0)
  end
end
