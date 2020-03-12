use Mix.Config

config :parallel, db_worker: Parallel.FileDatabaseWorker

import_config "#{Mix.env()}.exs"
