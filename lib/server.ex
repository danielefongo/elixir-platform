defmodule Parallel.Server do
  def start do
    spawn &(loop/0)
  end

  def run(server_pid, query_function) do
    send(server_pid, {self(), query_function})
  end

  def get_result do
    receive do
      {:result, message} -> message
      after 1000 -> {:error, :timeout}
    end
  end

  defp loop do
    receive do
      {caller, query_function} -> send caller, {:result, run_query(query_function)}
    end
    loop()
  end

  defp run_query(query) do
    :timer.sleep 500
    query
  end
end
