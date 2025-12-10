defmodule Day10Test do
  use ExUnit.Case, async: true

  @example_input "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"

  test "part1 example" do
    assert Day10.part1(@example_input) == 7
  end

  # test "part2 example" do
  #   assert Day10.part2(@example_input) == :todo
  # end
end
