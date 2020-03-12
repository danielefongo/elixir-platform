defmodule Parallel.System do
  def start_link do
    Supervisor.start_link(
      [
        Parallel.Registry,
        Parallel.Repo,
        Parallel.Database,
        Parallel.Cache,
        Parallel.Web
      ],
      strategy: :one_for_one
    )
  end
end
