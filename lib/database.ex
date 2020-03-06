defmodule Parallel.Database do
  use GenServer

  def start(folder) do
    GenServer.start(__MODULE__, folder, name: :database)
  end

  def store(key, data) do
    GenServer.cast(:database, {:store, key, data})
  end

  def load(key) do
    GenServer.call(:database, {:load, key})
  end

  def init(folder) do
    File.mkdir_p(folder)
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

end
