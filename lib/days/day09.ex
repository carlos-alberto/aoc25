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

  defp calculate_edge_nodes({x1, y1}, {x2, y2}) do
    for x <- min(x1, x2)..max(x1, x2),
        y <- min(y1, y2)..max(y1, y2),
        into: MapSet.new(),
        do: {x, y}
  end

  defp calculate_out_of_bounds({x1, y1}, {x2, y2}) do
    cond do
      # Horizontal edge
      y1 == y2 ->
        if x2 > x1 do
          for x <- x1..x2, into: MapSet.new(), do: {x, y1 - 1}
        else
          for x <- x2..x1, into: MapSet.new(), do: {x, y1 + 1}
        end

      # Vertical edge
      x1 == x2 ->
        if y2 > y1 do
          for y <- y1..y2, into: MapSet.new(), do: {x1 + 1, y}
        else
          for y <- y2..y1, into: MapSet.new(), do: {x1 - 1, y}
        end

      true ->
        MapSet.new()
    end
  end

  defp parse_coord(line) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp parse_input(input) do
    coords =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_coord/1)

    coords = coords ++ [hd(coords)]

    Enum.reduce(
      coords,
      %{red: MapSet.new(), out_of_bounds: MapSet.new(), all: MapSet.new(), prev: nil},
      fn coord, acc ->
        new_all =
          case acc.prev do
            nil -> MapSet.put(acc.all, coord)
            prev -> MapSet.union(acc.all, calculate_edge_nodes(prev, coord))
          end

        new_out_of_bounds =
          case acc.prev do
            nil ->
              acc.out_of_bounds

            prev ->
              MapSet.difference(
                MapSet.union(acc.out_of_bounds, calculate_out_of_bounds(prev, coord)),
                new_all
              )
          end

        %{
          red: MapSet.put(acc.red, coord),
          all: new_all,
          prev: coord,
          out_of_bounds: new_out_of_bounds
        }
      end
    )
  end

  def part1(input) do
    input
    |> parse_input()
    |> Map.get(:red)
    |> calculate_all_areas()
    |> Enum.max_by(fn {_coords_set, area} -> area end)
    |> elem(1)
  end

  defp rectangle_out_of_bounds?({x1, y1}, {x2, y2}, out_of_bounds) do
    xmin = min(x1, x2)
    xmax = max(x1, x2)
    ymin = min(y1, y2)
    ymax = max(y1, y2)

    perimeter =
      Stream.concat([
        Stream.map(xmin..xmax, fn x -> {x, ymin} end),
        Stream.map(xmin..xmax, fn x -> {x, ymax} end),
        Stream.map(ymin..ymax, fn y -> {xmin, y} end),
        Stream.map(ymin..ymax, fn y -> {xmax, y} end)
      ])

    Enum.any?(perimeter, &MapSet.member?(out_of_bounds, &1))
  end

  def part2(input) do
    parsed = parse_input(input)

    parsed
    |> Map.get(:red)
    |> calculate_all_areas()
    |> Enum.chunk_every(1000)
    |> Task.async_stream(
      fn chunk ->
        Enum.reduce(chunk, 0, fn {coords_set, area}, acc ->
          [coord1, coord2] = Enum.take(coords_set, 2)

          if rectangle_out_of_bounds?(coord1, coord2, parsed.out_of_bounds) do
            acc
          else
            max(acc, area)
          end
        end)
      end,
      max_concurrency: System.schedulers_online() * 2,
      ordered: false,
      timeout: :infinity
    )
    |> Enum.reduce(0, fn {:ok, chunk_max}, acc -> max(acc, chunk_max) end)
  end
end
