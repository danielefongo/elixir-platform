defmodule Parallel.Server do
  def start do
    spawn &(loop/0)
  end

  defp loop do
    receive do
      message -> IO.inspect message
    end
    loop()
  end
end
