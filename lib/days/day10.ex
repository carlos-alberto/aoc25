defmodule Day10 do
  @moduledoc """
  Advent of Code - Day 10
  """
  defp parse_buttons(button_strs) do
    button_strs
    |> Enum.map(fn s ->
      s
      |> String.slice(1..-2//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp parse_final(final_str) do
    final_str
    |> String.slice(1..-2//1)
    |> String.graphemes()
    |> Enum.map(&(&1 == "#"))
  end

  defp solve_line(line) do
    [end_str | button_strs] = String.split(line, " ")

    buttons = parse_buttons(Enum.drop(button_strs, -1))

    final = parse_final(end_str)

    init_state = Enum.map(final, fn _ -> false end)

    bfs(final, buttons, MapSet.new([init_state]), [{init_state, 0}])
  end

  defp bfs(final, _buttons, _visited, [{state, depth} | _]) when state == final do
    depth
  end

  defp bfs(final, buttons, visited, [{state, depth} | queue_tail]) do
    next_states =
      buttons
      |> Enum.map(fn button -> apply_button(state, button) end)
      |> Enum.reject(&MapSet.member?(visited, &1))

    new_visited =
      Enum.reduce(next_states, visited, fn s, acc -> MapSet.put(acc, s) end)

    new_queue =
      queue_tail ++ Enum.map(next_states, fn s -> {s, depth + 1} end)

    bfs(final, buttons, new_visited, new_queue)
  end

  defp apply_button(state, presses) do
    state
    |> Enum.with_index()
    |> Enum.map(fn {val, idx} -> if idx in presses, do: !val, else: val end)
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&solve_line/1)
    |> Enum.sum()
  end

  defp parse_line_part_2(line) do
    buttons =
      Regex.scan(~r/\(([\d,]+)\)/, line)
      |> Enum.map(fn [_, match] ->
        match |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)

    [_, target_str] = Regex.run(~r/\{([\d,]+)\}/, line)
    target = target_str |> String.split(",") |> Enum.map(&String.to_integer/1)

    {buttons, target}
  end

  defp build_smt_script({buttons, targets}) do
    vars = 0..(length(buttons) - 1) |> Enum.map(&"b#{&1}")

    declarations =
      Enum.map(vars, fn v -> "(declare-const #{v} Int)\n(assert (>= #{v} 0))" end)

    equations =
      targets
      |> Enum.with_index()
      |> Enum.map(fn {target_val, index_idx} ->
        # Find which buttons affect this index
        relevant_vars =
          buttons
          |> Enum.with_index()
          |> Enum.filter(fn {indices_in_button, _btn_idx} -> index_idx in indices_in_button end)
          |> Enum.map(fn {_, btn_idx} -> "b#{btn_idx}" end)

        "(assert (= (+ #{Enum.join(relevant_vars, " ")} 0) #{target_val}))"
      end)

    # Minimize sum of all buttons
    minimize = "(minimize (+ #{Enum.join(vars, " ")}))"

    """
    #{Enum.join(declarations, "\n")}
    #{Enum.join(equations, "\n")}
    #{minimize}
    (check-sat)
    (get-model)
    """
  end

  defp parse_z3_output(output) do
    if String.contains?(output, "unsat") do
      # You might want to raise or return 0 depending on problem rules
      IO.puts("No solution found for this line.")
      0
    else
      Regex.scan(~r/define-fun b\d+ \(\) Int\s+(\d+)/, output)
      |> Enum.map(fn [_, val_str] -> String.to_integer(val_str) end)
      |> Enum.sum()
    end
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line_part_2/1)
    |> Enum.map(&build_smt_script/1)
    |> Enum.map(fn smt_script ->
      temp_file = "solver_#{System.unique_integer([:positive])}.smt2"
      File.write!(temp_file, smt_script)
      {output, 0} = System.cmd("z3", [temp_file])
      File.rm(temp_file)
      parse_z3_output(output)
    end)
    |> Enum.sum()
  end
end
