defmodule Parallel.GenClient do
  def start do
    Parallel.GenServer.start(__MODULE__)
  end

  def put(pid, key, value) do
    Parallel.GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    Parallel.GenServer.call(pid, {:get, key})
  end

  def init do
    Map.new
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end
end
