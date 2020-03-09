defmodule Parallel.Supervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, nil)

  def init(_) do
    childs = [worker(Parallel.Cache, [Parallel.Bucket])]
    supervise(childs, strategy: :one_for_one)
  end
end
