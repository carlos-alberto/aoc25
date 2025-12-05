defmodule Mix.Tasks.Day do
  use Mix.Task

  @shortdoc "Run a specific Advent of Code day. Example: mix day 1"

  def run([day_str]) do
    day =
      case Integer.parse(day_str) do
        {n, _} -> n
        _ -> Mix.raise("Invalid day: #{day_str}")
      end

    input = AOC.load(day)

    # Build module name properly, without & captures
    mod =
      day
      |> Integer.to_string()
      |> String.pad_leading(2, "0")
      |> then(fn padded ->
        Module.concat([String.to_atom("Day" <> padded)])
      end)

    # Ensure module exists
    unless Code.ensure_loaded?(mod) do
      Mix.raise("No module found for #{inspect(mod)}")
    end

    part1 = apply(mod, :part1, [input])
    part2 = apply(mod, :part2, [input])

    Mix.shell().info("Day #{day}")
    Mix.shell().info("  Part 1: #{inspect(part1)}")
    Mix.shell().info("  Part 2: #{inspect(part2)}")
  end

  def run(_args) do
    Mix.raise("Usage: mix day <number>")
  end
end
