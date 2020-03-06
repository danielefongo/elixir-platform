defmodule Parallel.Server do
  def start do
    spawn &(loop/0)
  end

  defp loop do
    receive do
      {:async, message} -> IO.inspect message
      {:sync, caller, message} -> send caller, message
    end
    loop()
  end
end
