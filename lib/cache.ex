defmodule Parallel.Cache do
  use GenServer

  def start(module_callback, opts \\ []) do
    GenServer.start(__MODULE__, module_callback, opts)
  end

  def bucket(pid, key) do
    GenServer.call(pid, {:bucket, key})
  end

  def init(module) do
    Parallel.Database.start("./data/persist")
    {:ok, %{module: module, map: Map.new()}}
  end

  def handle_call({:bucket, bucket_name}, _, %{module: module, map: buckets}) do
    case Map.fetch(buckets, bucket_name) do
      {:ok, bucket} -> {:reply, bucket, buckets}
      :error ->
        {:ok, new_bucket} = module.start(bucket_name)
        buckets = Map.put(buckets, bucket_name, new_bucket)
        {:reply, new_bucket, buckets}
    end
  end
end
