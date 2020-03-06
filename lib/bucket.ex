defmodule Parallel.Bucket do
  use GenServer

  def start(bucket_name) do
    GenServer.start(__MODULE__, bucket_name, [])
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  @spec get(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def init(bucket_name) do
    IO.puts "Bucket #{bucket_name} started."
    {:ok, {bucket_name, Map.new}}
  end

  def handle_cast({:put, key, value}, {bucket_name, map}) do
    {:noreply, {bucket_name, Map.put(map, key, value)}}
  end

  def handle_call({:get, key}, _, {bucket_name, map}) do
    {:reply, Map.get(map, key), {bucket_name, map}}
  end
end
