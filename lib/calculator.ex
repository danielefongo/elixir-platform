defmodule Parallel.Calculator do
  def start(value) do
    pid = spawn(fn -> loop(value) end)
    Process.register(pid, :calculator) #remember that atoms are not garbage-collected
    {:ok}
  end

  defp loop(value) do
    value = receive do
      query -> handle_op(value, query)
    end
    loop(value)
  end

  def sum(value), do: send(:calculator, {:sum, value})
  def min(value), do: send(:calculator, {:min, value})
  def mul(value), do: send(:calculator, {:mul, value})
  def div(value), do: send(:calculator, {:div, value})
  def value() do
    send(:calculator, {:value, self()})
    receive do
      {:response, value} -> value
    end
  end

  defp handle_op(current_value, {:sum, value}), do: current_value + value
  defp handle_op(current_value, {:min, value}), do: current_value - value
  defp handle_op(current_value, {:mul, value}), do: current_value * value
  defp handle_op(current_value, {:div, value}), do: current_value / value
  defp handle_op(current_value, {:value, caller}) do
    send caller, {:response, current_value}
    current_value
  end
end
