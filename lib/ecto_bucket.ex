defmodule Parallel.EctoBucket do
  use Ecto.Schema
  import Ecto.Query

  schema "buckets" do
    field :name, :string
    field :values, :map, default: Map.new
  end

  def new(key), do: %Parallel.EctoBucket{name: key}

  def newmap_changeset(bucket, params \\ %{}) do
    bucket
    |> Ecto.Changeset.cast(params, [:values])
    |> Ecto.Changeset.validate_required([:values])
  end

  defmodule Queries do
    def find(key) do
      from bucket in Parallel.EctoBucket,
          where: bucket.name == ^key,
          select: bucket
    end
  end
end
