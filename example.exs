Parallel.System.start_link

Parallel.Cache.bucket("1")

[{worker_pid, _}] = Registry.lookup(
  Parallel.Registry,
  {Parallel.Bucket, "1"}
)

Process.exit(worker_pid, :kill)

:timer.sleep 100

IO.puts "..."

bucket = Parallel.Cache.bucket("1")
Parallel.Bucket.put(bucket, "key", "value")
value = Parallel.Bucket.get(bucket, "key")
IO.inspect value

Process.sleep(:timer.seconds(10))
