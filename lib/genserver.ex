defmodule Parallel.GenServer do
  def start(callback_module) do
    init_state = callback_module.init
    spawn(fn -> loop(callback_module, init_state) end)
  end

  def call(server_pid, request) do
    send(server_pid, {:call, self(), request})
    receive do
       {:response, response} -> response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  defp loop(callback_module, state) do
    receive do
      {:cast, request} ->
        {:noreply, new_state} = callback_module.handle_cast(request, state)
        loop(callback_module, new_state)
      {:call, caller, request} ->
        {response, new_state} = callback_module.handle_call(request, state)

        send(caller, {:response, response})
        loop(callback_module, new_state)
    end
  end
end
