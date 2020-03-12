use Mix.Config

config :parallel, Parallel.Repo,
  database: "dbname",
  username: "root",
  password: "dbpass",
  hostname: "localhost",
  port: 3306

config :parallel, db_worker: Parallel.FileDatabaseWorker

import_config "#{Mix.env()}.exs"
