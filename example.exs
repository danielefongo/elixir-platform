pid = Parallel.Server.start()
send pid, "Hello"
send pid, "World"

:timer.sleep 1000
