defmodule Parallel.System do
  def start_link do
    Supervisor.start_link(
      [
        Parallel.Registry,
        Parallel.Database,
        Parallel.Cache
      ],
      strategy: :one_for_one
    )
  end
end
