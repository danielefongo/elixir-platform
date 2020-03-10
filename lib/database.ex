defmodule Parallel.Database do
  use GenServer

  @workers 3
  @folder "data/persist"

  def start_link(opts \\ nil) do
    IO.puts "Starting database"
    GenServer.start_link(__MODULE__, opts, name: :database)
  end

  def store(key, data) do
    GenServer.cast(:database, {:store, key, data})
  end

  def load(key) do
    GenServer.call(:database, {:load, key})
  end

  def init(_) do
    workers = 1..@workers
      |> Enum.map(fn number -> {number, Parallel.DatabaseWorker.start_link(@folder)} end)
      |> Map.new

    {:ok, workers}
  end

  def handle_cast({:store, key, data}, workers) do
    worker = worker_for(workers, key)
    Parallel.DatabaseWorker.store(worker, key, data)
    {:noreply, worker}
  end

  def handle_call({:load, key}, _, workers) do
    worker = worker_for(workers, key)
    data = Parallel.DatabaseWorker.load(worker, key)
    {:reply, data, workers}
  end

  defp worker_for(workers, key), do: Map.get(workers, :erlang.phash2(key, @workers) + 1)
end
