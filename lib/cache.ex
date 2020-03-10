defmodule Parallel.Cache do
  def start_link do
    IO.puts "Starting cache"
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def child_spec(_any) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def bucket(bucket_name) do
    case start_child(bucket_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  defp start_child(bucket_name) do
    # not fast solution
    DynamicSupervisor.start_child(__MODULE__, {Parallel.Bucket, bucket_name})
  end
end
