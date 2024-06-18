defmodule MediaServer.People do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:id]
  }

  schema "people" do
    field :tmdb_id, :integer
    field :name, :string
    field :image, :string

    timestamps()
  end

  def changeset(people, attrs) do
    people
    |> cast(attrs, [:tmdb_id, :name, :image])
    |> validate_required([:tmdb_id, :name, :image])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: [set: [name: Ecto.Changeset.get_field(changeset, :name), image: Ecto.Changeset.get_field(changeset, :image)]], conflict_target: [:tmdb_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
