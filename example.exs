import Enum

pool = 1..10
  |> map(fn(_) -> Parallel.Server.start end)

1..10
  |> each(fn query ->
    server_pid = at(pool, :random.uniform(10) - 1)
    Parallel.Server.run(server_pid, query)
  end)

messages = 1..10
  |> map(fn _ -> Parallel.Server.get_result end)

IO.inspect messages


Parallel.Calculator.start(3)
Parallel.Calculator.sum(3)
Parallel.Calculator.div(2)
IO.inspect Parallel.Calculator.value()

{:ok, pid} = Parallel.GenClient.start()
Parallel.GenClient.put(pid, "key", "value")
value = Parallel.GenClient.get(pid, "key")
IO.inspect value
