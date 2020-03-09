defmodule Parallel.Database do
  use GenServer

  @workers 3

  def start_link(folder) do
    IO.puts "Starting database"
    GenServer.start_link(__MODULE__, folder, name: :database)
  end

  def store(key, data) do
    GenServer.cast(:database, {:store, key, data})
  end

  def load(key) do
    GenServer.call(:database, {:load, key})
  end

  def init(folder) do
    send(self(), {:init, folder})
    {:ok, nil}
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

  def handle_info({:init, folder}, _) do
    File.mkdir_p(folder)

    workers = 1..@workers
    |> Enum.map(fn number -> {number, Parallel.DatabaseWorker.start_link(folder)} end)
    |> Map.new
    {:noreply, workers}
  end

  defp worker_for(workers, key), do: Map.get(workers, :erlang.phash2(key, @workers) + 1)
end
