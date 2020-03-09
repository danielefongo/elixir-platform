defmodule Parallel.Bucket do
  use GenServer

  def start(bucket_name) do
    GenServer.start(__MODULE__, bucket_name, [])
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def init(bucket_name) do
    IO.puts "Bucket #{bucket_name} started."
    send(self(), {:init, bucket_name})
    {:ok, nil}
  end

  def handle_cast({:put, key, value}, {bucket_name, map}) do
    new_map = Map.put(map, key, value)
    Parallel.Database.store(bucket_name, new_map)
    {:noreply, {bucket_name, new_map}}
  end

  def handle_call({:get, key}, _, {bucket_name, map}) do
    {:reply, Map.get(map, key), {bucket_name, map}}
  end

  def handle_info({:init, bucket_name}, _state) do
    {:noreply, {bucket_name, Parallel.Database.load(bucket_name) || Map.new}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

end
