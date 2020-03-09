defmodule Parallel.Cache do
  use GenServer

  def start_link(module_callback, _opts \\ []) do
    GenServer.start_link(__MODULE__, module_callback, name: :cache)
  end

  def bucket(key) do
    GenServer.call(:cache, {:bucket, key})
  end

  def init(module) do
    Parallel.Database.start("./data/persist")
    {:ok, %{module: module, map: Map.new()}}
  end

  def handle_call({:bucket, bucket_name}, _, %{module: module, map: buckets}) do
    case Map.fetch(buckets, bucket_name) do
      {:ok, bucket} -> {:reply, bucket, %{module: module, map: buckets}}
      :error ->
        {:ok, new_bucket} = module.start(bucket_name)
        buckets = Map.put(buckets, bucket_name, new_bucket)
        {:reply, new_bucket, %{module: module, map: buckets}}
    end
  end
end
