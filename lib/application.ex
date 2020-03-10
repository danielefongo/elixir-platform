defmodule Parallel.Application do
  use Application

  def start(_, _) do
    Parallel.System.start_link
  end
end
