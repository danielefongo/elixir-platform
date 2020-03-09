{:ok, pid} = Parallel.Cache.start(Parallel.Bucket)
bucket = Parallel.Cache.bucket(pid,"1")
Parallel.Bucket.put(bucket, "key", "value")
value = Parallel.Bucket.get(bucket, "key")
IO.inspect value
