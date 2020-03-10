defmodule Parallel.DatabaseWorker do
  use GenServer

  def start_link({folder, id}) do
    IO.puts "Starting database worker #{id}"
    GenServer.start_link(__MODULE__, folder, name: via_tuple(id))
  end

  def store(id, key, data) do
    GenServer.cast(via_tuple(id), {:store, key, data})
  end

  def load(id, key) do
    GenServer.call(via_tuple(id), {:load, key})
  end

  def init(folder) do
    {:ok, folder}
  end

  def handle_cast({:store, key, data}, folder) do
    write(folder, key, binary(data))

    {:noreply, folder}
  end

  def handle_call({:load, key}, _, folder) do
    data = case read(folder, key) do
      {:ok, data} -> erlang(data)
      _ -> nil end
    {:reply, data, folder}
  end

  defp file_name(folder, key), do: "#{folder}/#{key}"
  defp write(folder, key, data), do: file_name(folder, key) |> File.write!(data)
  defp read(folder, key), do: File.read(file_name(folder, key))
  defp binary(erlang_data), do: :erlang.term_to_binary(erlang_data)
  defp erlang(binary_data), do: :erlang.binary_to_term(binary_data)
  defp via_tuple(worker_id) do
    Parallel.Registry.via_tuple({__MODULE__, worker_id})
  end
end
