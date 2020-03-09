Parallel.Cache.start_link(Parallel.Bucket)
bucket = Parallel.Cache.bucket("1")
Parallel.Bucket.put(bucket, "key", "value")
value = Parallel.Bucket.get(bucket, "key")
IO.inspect value
