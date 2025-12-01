defmodule AOC do
  @moduledoc """
  Advent of Code helper functions.
  """

  def load(day) do
    day_str =
      day
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    Path.join(["input", "day#{day_str}.txt"])
    |> File.read!()
    |> String.trim_trailing()
  end
end