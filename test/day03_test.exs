defmodule Day03Test do
  use ExUnit.Case, async: true

  @example_input "987654321111111
811111111111119
234234234234278
818181911112111"

  test "part1 example" do
    assert Day03.part1(@example_input) == 357
  end

  test "part2 example" do
    assert Day03.part2(@example_input) == 3_121_910_778_619
  end
end
