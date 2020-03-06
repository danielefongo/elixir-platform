defmodule Parallel.Bucket do
  use GenServer

  def start(opts \\ nil) do
    GenServer.start(__MODULE__, opts)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  @spec get(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def init(_) do
    {:ok, Map.new}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end
end
