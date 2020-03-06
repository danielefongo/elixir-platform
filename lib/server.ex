defmodule Parallel.Server do
  def start do
    spawn(fn -> loop(1) end)
  end

  def run(server_pid, query) do
    send(server_pid, {self(), query})
  end

  def get_result do
    receive do
      {:result, message} -> message
      after 1000 -> {:error, :timeout}
    end
  end

  defp loop(number) do
    receive do
      {caller, query} -> send caller, {:result, run_query(number, query)}
    end
    loop(number + 1)
  end

  defp run_query(number, query) do
    IO.inspect("Serving query number: " <> Kernel.inspect(number))
    :timer.sleep 500
    query
  end
end
