defmodule Parallel.Database do
  use GenServer

  @workers 3

  def start(folder) do
    GenServer.start(__MODULE__, folder, name: :database)
  end

  def store(key, data) do
    GenServer.cast(:database, {:store, key, data})
  end

  def load(key) do
    GenServer.call(:database, {:load, key})
  end

  def init(folder) do
    File.mkdir_p(folder)

    workers = 1..@workers
      |> Enum.map(fn number -> {number, Parallel.DatabaseWorker.start(folder)} end)
      |> Map.new
    {:ok, workers}
  end

  def handle_cast({:store, key, data}, workers) do
    worker = worker_for(workers, key)
    Parallel.DatabaseWorker.store(worker, key, data)
    {:noreply, worker}
  end

  def handle_call({:load, key}, caller, workers) do
    worker = worker_for(workers, key)
    Parallel.DatabaseWorker.load(worker, key, caller)
    {:noreply, workers}
  end

  defp worker_for(workers, key), do: Map.get(workers, :erlang.phash2(key, @workers) + 1)
end
