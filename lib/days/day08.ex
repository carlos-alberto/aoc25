defmodule Day08 do
  @moduledoc """
  Advent of Code - Day 08
  """
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.sort()
  end

  defp push_heap(heap, item, n) do
    heap = [item | heap] |> Enum.sort_by(& &1.distance, :desc)

    if length(heap) > n do
      tl(heap)
    else
      heap
    end
  end

  defp calculate_distances(coords, n) do
    pairs =
      for {c1, i} <- Enum.with_index(coords),
          c2 <- Enum.drop(coords, i + 1) do
        {c1, c2}
      end

    pairs
    |> Task.async_stream(
      fn {c1, c2} ->
        %{pair: {c1, c2}, distance: calculate_distance(c1, c2)}
      end,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.reduce([], fn {:ok, result}, heap ->
      push_heap(heap, result, n)
    end)
  end

  defp calculate_distance({x1, y1, z1}, {x2, y2, z2}) do
    (:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2) + :math.pow(z2 - z1, 2))
    |> :math.sqrt()
  end

  defp make_circuits(connections) do
    connections
    |> Enum.reduce([], fn %{pair: {a, b}}, circuits ->
      set = MapSet.new([a, b])
      merge_into_circuits(circuits, set)
    end)
  end

  defp merge_into_circuits(circuits, set) do
    {overlapping, disjoint} =
      Enum.split_with(circuits, fn c ->
        not MapSet.disjoint?(c, set)
      end)

    merged =
      Enum.reduce(overlapping, set, fn c, acc ->
        MapSet.union(acc, c)
      end)

    [merged | disjoint]
  end

  defp reduce_circuits(circuits) do
    reduced =
      Enum.reduce(circuits, [], fn circuit, acc ->
        merge_into_circuits(acc, circuit)
      end)

    if length(reduced) == length(circuits) do
      reduced
    else
      reduce_circuits(reduced)
    end
  end

  def part1(input) do
    part1(input, 1000)
  end

  def part1(input, count) do
    input
    |> parse_input()
    |> calculate_distances(count)
    |> make_circuits()
    |> reduce_circuits()
    |> Enum.sort_by(&MapSet.size/1, :desc)
    |> Enum.take(3)
    |> Enum.map(&MapSet.size/1)
    |> Enum.product()
  end

  def part2(_input) do
    :nottodo
  end
end
