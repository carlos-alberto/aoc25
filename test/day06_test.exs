defmodule Day06Test do
  use ExUnit.Case, async: true

  @example_input "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  "

  test "part1 example" do
    assert Day06.part1(@example_input) == 4_277_556
  end

  test "part2 example" do
    assert Day06.part2(@example_input) == 3_263_827
  end
end
