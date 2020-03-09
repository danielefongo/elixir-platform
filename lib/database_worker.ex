defmodule Parallel.DatabaseWorker do
  use GenServer

  def start_link(folder) do
    {:ok, pid} = GenServer.start_link(__MODULE__, folder)
    pid
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end

  def load(pid, key, caller) do
    GenServer.cast(pid, {:load, key, caller})
  end

  def init(folder) do
    {:ok, folder}
  end

  def handle_cast({:store, key, data}, folder) do
    write(folder, key, binary(data))

    {:noreply, folder}
  end

  def handle_cast({:load, key, caller}, folder) do
    data = case read(folder, key) do
      {:ok, data} -> erlang(data)
      _ -> nil end
    GenServer.reply(caller, data)
    {:noreply, folder}
  end

  defp file_name(folder, key), do: "#{folder}/#{key}"
  defp write(folder, key, data), do: file_name(folder, key) |> File.write!(data)
  defp read(folder, key), do: File.read(file_name(folder, key))
  defp binary(erlang_data), do: :erlang.term_to_binary(erlang_data)
  defp erlang(binary_data), do: :erlang.binary_to_term(binary_data)

end
