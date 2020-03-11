defmodule Parallel.Env do
  def get!(prop), do: Application.fetch_env!(:parallel, prop)
end
