pid = Parallel.Server.start()

Parallel.Server.run(pid, "Echo me!")
Parallel.Server.run(pid, "Echo me again!")

message = 1..3 |> Enum.map(fn _ -> Parallel.Server.get_result() end)
IO.inspect message
