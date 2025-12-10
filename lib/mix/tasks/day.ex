defmodule Mix.Tasks.Day do
  use Mix.Task

  @shortdoc "Run a specific Advent of Code day. Example: mix day 1 or mix day 1 --part 2"

  def run([day_str]) do
    do_run(day_str, :both)
  end

  def run([day_str, "--part", part_str]) do
    part =
      case part_str do
        "1" -> :one
        "2" -> :two
        _ -> Mix.raise("Invalid part: #{part_str}")
      end

    do_run(day_str, part)
  end

  def do_run(day_str, part) do
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

    case part do
      :one ->
        result = apply(mod, :part1, [input])
        Mix.shell().info("Day #{day} - Part one: #{inspect(result)}")

      :two ->
        result = apply(mod, :part2, [input])
        Mix.shell().info("Day #{day} - Part two: #{inspect(result)}")

      :both ->
        part1 = apply(mod, :part1, [input])
        part2 = apply(mod, :part2, [input])
        Mix.shell().info("Day #{day} - Part one: #{inspect(part1)}")
        Mix.shell().info("Day #{day} - Part two: #{inspect(part2)}")
    end
  end

  def help do
    Mix.shell().info("""
    Usage: mix day <day_number> [--part <part_number>]

    Runs the specified day's solution. If --part is not provided, runs both parts.

    Examples:
      mix day 1
      mix day 2 --part 1
      mix day 10 --part 2
    """)
  end
end
