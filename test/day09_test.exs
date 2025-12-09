defmodule Day09Test do
  use ExUnit.Case, async: true

  @example_input "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3"

  test "part1 example" do
    assert Day09.part1(@example_input) == 50
  end

  test "part2 example" do
    assert Day09.part2(@example_input) == 24
  end
end
