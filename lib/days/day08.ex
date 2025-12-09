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

  def calculate_distances(coords) do
    do_calculate(coords, [])
  end

  defp do_calculate([], results), do: List.flatten(results)

  defp do_calculate([current_point | rest_points], results) do
    task = Task.async(fn ->
      Enum.map(rest_points, fn other_point ->
        %{
          pair: {current_point, other_point},
          distance: calculate_distance(current_point, other_point)
        }
      end)
    end)

    do_calculate(rest_points, [task | results])
  end

  def await_results(tasks) do
    tasks
    |> Task.await_many()
    |> List.flatten()
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
    |> calculate_distances()
    |> await_results()
    |> Enum.sort_by(& &1.distance)
    |> Enum.take(count)
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
