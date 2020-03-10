Parallel.System.start_link

[{worker_pid, _}] = Registry.lookup(
  Parallel.Registry,
  {Parallel.DatabaseWorker, 2}
)

Process.exit(worker_pid, :kill)

:timer.sleep 100

bucket = Parallel.Cache.bucket("1")
Parallel.Bucket.put(bucket, "key", "value")
value = Parallel.Bucket.get(bucket, "key")
IO.inspect value
