defmodule Day04Test do
  use ExUnit.Case, async: true

  @example_input "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."

  test "part1 example" do
    assert Day04.part1(@example_input) == 13
  end

  test "part2 example" do
    assert Day04.part2(@example_input) == 43
  end
end
