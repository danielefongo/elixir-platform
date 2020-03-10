defmodule Parallel.Cache do
  use GenServer

  def start_link(opts \\ nil) do
    IO.puts "Starting cache"
    GenServer.start_link(__MODULE__, opts, name: :cache)
  end

  def bucket(key) do
    GenServer.call(:cache, {:bucket, key})
  end

  def init(_opts) do
    {:ok, Map.new()}
  end

  def handle_call({:bucket, bucket_name}, _, buckets) do
    case Map.fetch(buckets, bucket_name) do
      {:ok, bucket} -> {:reply, bucket, buckets}
      :error ->
        {:ok, new_bucket} = Parallel.Bucket.start_link(bucket_name)
        buckets = Map.put(buckets, bucket_name, new_bucket)
        {:reply, new_bucket, buckets}
    end
  end
end
