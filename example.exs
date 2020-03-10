Parallel.System.start_link

Process.whereis(:cache) |> Process.exit(:kill)

:timer.sleep 100

bucket = Parallel.Cache.bucket("1")
Parallel.Bucket.put(bucket, "key", "value")
value = Parallel.Bucket.get(bucket, "key")
IO.inspect value
