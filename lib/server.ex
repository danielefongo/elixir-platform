defmodule Parallel.Server do
  def start do
    spawn &(loop/0)
  end

  def sync(server_pid, query_def) do
    send(server_pid, {:sync, self(), query_def})
  end

  def async(server_pid, query_def) do
    send(server_pid, {:async, query_def})
  end

  def sync_result do
    receive do
      {:result, message} -> message
      after 1000 -> {:error, :timeout}
    end
  end

  defp loop do
    receive do
      {:async, message} -> print message
      {:sync, caller, message} -> send caller, {:result, message}
    end
    loop()
  end

  defp print(data), do: IO.inspect data
end
