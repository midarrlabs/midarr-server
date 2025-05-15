defmodule MediaServer.Genres do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name],
    sortable: [:id, :name]
  }

  schema "genres" do
    field :tmdb_id, :integer
    field :name, :string

    many_to_many :movies, MediaServer.Movies, join_through: "movie_genres"

    timestamps()
  end

  def changeset(people, attrs) do
    people
    |> cast(attrs, [:tmdb_id, :name])
    |> validate_required([:tmdb_id, :name])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: [set: [name: Ecto.Changeset.get_field(changeset, :name)]], conflict_target: [:tmdb_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
