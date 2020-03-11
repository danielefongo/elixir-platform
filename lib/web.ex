defmodule Parallel.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def child_spec(_arg) do
    a = Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: 5454],
      plug: __MODULE__
    )
  end

  post "/put" do
    conn = Plug.Conn.fetch_query_params(conn)
    bucket = Map.fetch!(conn.params, "bucket")
    key = Map.fetch!(conn.params, "key")
    value = Map.fetch!(conn.params, "value")

    bucket
      |> Parallel.Cache.bucket
      |> Parallel.Bucket.put(key, value)

    conn
      |> Plug.Conn.put_resp_content_type("text/plain")
      |> Plug.Conn.send_resp(200, "OK")
  end

  get "/get" do
    conn = Plug.Conn.fetch_query_params(conn)
    bucket = Map.fetch!(conn.params, "bucket")
    key = Map.fetch!(conn.params, "key")

    value = bucket
      |> Parallel.Cache.bucket
      |> Parallel.Bucket.get(key)

    conn
      |> Plug.Conn.put_resp_content_type("text/plain")
      |> Plug.Conn.send_resp(200, value)
  end
end
