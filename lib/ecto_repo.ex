defmodule Parallel.Repo do
  use Ecto.Repo,
    otp_app: :parallel,
    adapter: Ecto.Adapters.MyXQL
end
