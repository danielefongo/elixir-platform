defmodule Parallel.Database do
  @workers 3
  @folder "data/persist"

  def start_link do
    File.mkdir_p!(@folder)
    children = Enum.map(1..@workers, &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  defp worker_spec(worker_id) do
    default_worker_spec = {Parallel.DatabaseWorker, {@folder, worker_id}}
    Supervisor.child_spec(default_worker_spec, id: worker_id)
  end

  def store(key, data) do
    key
      |> worker_for
      |> Parallel.DatabaseWorker.store(key, data)
  end

  def load(key) do
    key
      |> worker_for
      |> Parallel.DatabaseWorker.load(key)
  end

  defp worker_for(key), do: :erlang.phash2(key, @workers) + 1
end
