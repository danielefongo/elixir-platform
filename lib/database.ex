defmodule Parallel.Database do
  use GenServer

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
    Parallel.DatabaseWorker.start(folder)
  end

  def handle_cast({:store, key, data}, worker) do
    Parallel.DatabaseWorker.store(worker, key, data)
    {:noreply, worker}
  end

  def handle_call({:load, key}, caller, worker) do
    Parallel.DatabaseWorker.load(worker, key, caller)
    {:noreply, worker}
  end

end
