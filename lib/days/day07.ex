defmodule Day07 do
  @moduledoc """
  Advent of Code - Day 07
  """

  def parse_to_grid(rows) do
    height = length(rows)
    width = rows |> hd() |> String.length()

    {splitters, starts} =
      for {line, y} <- Enum.with_index(rows),
          {char, x} <- Enum.with_index(String.graphemes(line)),
          reduce: {MapSet.new(), []} do
        {splitters, starts} ->
          case char do
            "^" -> {MapSet.put(splitters, {x, y}), starts}
            "S" -> {splitters, [{x, y} | starts]}
            _ -> {splitters, starts}
          end
      end

    %{
      splitters: splitters,
      starts: starts,
      height: height,
      width: width
    }
  end

  defp track_beams(%{starts: starts} = grid, used_splitters) do
    track_beams(starts, grid, used_splitters)
  end

  defp track_beams([], _grid, used_splitters), do: used_splitters

  defp track_beams([{_x, y} | rest], %{height: height} = grid, used)
       when y >= height do
    track_beams(rest, grid, used)
  end

  defp track_beams([pos | rest], grid, used) do
    {x, y} = pos

    case determine_action(pos, grid, used) do
      :stop ->
        track_beams(rest, grid, used)

      :continue ->
        track_beams([{x, y + 1} | rest], grid, used)

      :split ->
        left = {x - 1, y}
        right = {x + 1, y}

        new_used =
          Map.update(used, pos, %{left: 1, right: 1}, fn counts ->
            %{
              left: counts.left + 1,
              right: counts.right + 1
            }
          end)

        track_beams([left, right | rest], grid, new_used)
    end
  end

  defp determine_action(pos, %{splitters: splitters}, used) do
    is_splitter = MapSet.member?(splitters, pos)

    cond do
      not is_splitter ->
        :continue

      not Map.has_key?(used, pos) ->
        :split

      true ->
        :stop
    end
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> parse_to_grid()
    |> track_beams(%{})
    |> map_size()
  end

  defp count_paths(%{starts: starts} = grid, memo) do
    Enum.reduce(starts, {0, memo}, fn start, {acc_paths, memo} ->
      {paths, memo} = count_paths_from(start, grid, memo)
      {acc_paths + paths, memo}
    end)
  end

  defp count_paths_from({_x, y}, %{height: height}, memo) when y >= height do
    {1, memo}
  end

  defp count_paths_from({x, _y}, %{width: width}, memo) when x < 0 or x >= width do
    {1, memo}
  end

  defp count_paths_from(pos = {x, y}, grid = %{splitters: splitters}, memo) do
    case memo do
      %{^pos => cached} ->
        {cached, memo}

      _ ->
        {paths, memo_after_children} =
          if MapSet.member?(splitters, pos) do
            {left_paths, memo1} = count_paths_from({x - 1, y + 1}, grid, memo)
            {right_paths, memo2} = count_paths_from({x + 1, y + 1}, grid, memo1)

            {left_paths + right_paths, memo2}
          else
            count_paths_from({x, y + 1}, grid, memo)
          end

        {paths, Map.put(memo_after_children, pos, paths)}
    end
  end

  def part2(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> parse_to_grid()

    {paths, _memo} = count_paths(grid, %{})
    paths
  end
end
