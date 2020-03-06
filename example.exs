receive_and_print = fn ->
  receive do
    message -> IO.inspect ("Received: '" <> message <> "'")
  end
end

myself = self()
pid = Parallel.Server.start()
send pid, {:async, "Hello"}
send pid, {:async, "World"}

send pid, {:sync, myself, "Echo me!"}
send pid, {:sync, myself, "Echo me another time!"}

receive_and_print.()
receive_and_print.()
