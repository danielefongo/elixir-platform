Parallel.Supervisor.start_link
_ = Parallel.Cache.bucket("1")
bucket = Parallel.Cache.bucket("1")
Parallel.Bucket.put(bucket, "key", "value")

Process.whereis(:cache) |> Process.exit(:kill)

value = Parallel.Bucket.get(bucket, "key")
IO.inspect value
