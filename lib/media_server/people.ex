defmodule MediaServer.People do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :tmdb_id, :integer

    timestamps()
  end

  def changeset(people, attrs) do
    people
    |> cast(attrs, [:tmdb_id])
    |> validate_required([:tmdb_id])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:tmdb_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
