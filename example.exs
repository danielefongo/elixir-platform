pid = Parallel.Server.start()

Parallel.Server.async(pid, "Hello")
Parallel.Server.async(pid, "World")

Parallel.Server.sync(pid, "Echo me!")
Parallel.Server.sync(pid, "Echo me again!")

message = 1..3 |> Enum.map(fn _ -> Parallel.Server.sync_result() end)
IO.inspect message
