defmodule Parallel.Calculator do
  def start(value) do
    spawn(fn -> loop(value) end)
  end

  defp loop(value) do
    value = receive do
      query -> handle_op(value, query)
    end
    loop(value)
  end

  def sum(pid, value), do: send(pid, {:sum, value})
  def min(pid, value), do: send(pid, {:min, value})
  def mul(pid, value), do: send(pid, {:mul, value})
  def div(pid, value), do: send(pid, {:div, value})
  def value(pid) do
    send(pid, {:value, self()})
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
