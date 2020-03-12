defmodule Parallel.EctoDatabaseWorker do
  use GenServer
  alias Parallel.{Repo}
  alias Parallel.EctoBucket, as: Bucket

  def start_link(_) do
    IO.puts "Starting ecto database worker"
    GenServer.start_link(__MODULE__, nil)
  end

  def store(_, key, data) do
    key
      |> bucket_from
      |> Bucket.newmap_changeset(%{values: data})
      |> Repo.update
  end

  def load(_, key) do
    case bucket_from(key) do
      nil ->
        bucket = Bucket.new(key)
        Repo.insert(bucket)
        bucket.values
      bucket -> bucket.values
    end
  end

  def init(_) do
    {:ok, nil}
  end

  defp bucket_from(key) do
    key
      |> Bucket.Queries.find
      |> Repo.one
  end
end

defmodule Parallel.FileDatabaseWorker do
  use GenServer

  def start_link(folder) do
    IO.puts "Starting file database worker"
    GenServer.start_link(__MODULE__, folder)
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end

  def load(pid, key) do
    GenServer.call(pid, {:load, key})
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
end
