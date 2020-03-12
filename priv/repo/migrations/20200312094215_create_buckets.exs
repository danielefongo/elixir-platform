defmodule Parallel.Repo.Migrations.CreateBuckets do
  use Ecto.Migration

  def change do
    create table(:buckets) do
      add :name, :string
      add :values, :map
    end
  end
end
