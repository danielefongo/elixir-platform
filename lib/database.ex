defmodule Parallel.Database do
  @folder "data/persist"

  def child_spec(_) do
    File.mkdir_p!(@folder) # meh

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Parallel.DatabaseWorker,
        size: 3
      ],
      [@folder]
    )
  end

  def store(key, data) do
    :poolboy.transaction(
      __MODULE__,
      &(Parallel.DatabaseWorker.store(&1, key, data))
    )
  end

  def load(key) do
    :poolboy.transaction(
      __MODULE__,
      &(Parallel.DatabaseWorker.load(&1, key))
    )
  end
end
