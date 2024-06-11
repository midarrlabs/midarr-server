defmodule MediaServer.Movies do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :external_id, :integer

    timestamps()
  end

  def changeset(movies, attrs) do
    movies
    |> cast(attrs, [:external_id])
    |> validate_required([:external_id])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:external_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
