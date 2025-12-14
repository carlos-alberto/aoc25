defmodule Day11Test do
  use ExUnit.Case, async: true

  @example_input "aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out"

  @example_input2 "svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out"

  test "part1 example" do
    assert Day11.part1(@example_input) == 5
  end

  test "part2 example" do
    assert Day11.part2(@example_input2) == 2
  end
end
