defmodule Day05Test do
  use ExUnit.Case, async: true

  @example_input "3-5
10-14
16-20
12-18

1
5
8
11
17
32"

  test "part1 example" do
    assert Day05.part1(@example_input) == 3
  end

  test "part2 example" do
    assert Day05.part2(@example_input) == 14
  end
end
