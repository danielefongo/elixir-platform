use Mix.Config

config :parallel, Parallel.Repo,
  database: "dbname",
  username: "root",
  password: "dbpass",
  hostname: "localhost",
  port: 3306

config :parallel, ecto_repos: [Parallel.Repo]
config :parallel, db_worker: Parallel.EctoDatabaseWorker

import_config "#{Mix.env()}.exs"
