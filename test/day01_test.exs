defmodule Day01Test do
  use ExUnit.Case, async: true

  @example_input "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  test "part1 example" do
    assert Day01.part1(@example_input) == 3
  end

  test "part2 example" do
    assert Day01.part2(@example_input) == 6
  end
end
