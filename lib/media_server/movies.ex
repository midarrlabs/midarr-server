defmodule MediaServer.Movies do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :title, :overview, :year, :poster, :background, :path]
  }

  @derive {
    Flop.Schema,
    filterable: [:title],
    sortable: [:id, :title]
  }

  schema "movies" do
    field :tmdb_id, :integer
    field :title, :string
    field :overview, :string
    field :year, :integer
    field :poster, :string
    field :background, :string
    field :path, :string

    has_one :continue, MediaServer.MovieContinues, foreign_key: :movies_id
    many_to_many :genres, MediaServer.Genres, join_through: "movie_genres"

    timestamps()
  end

  def changeset(movies, attrs) do
    movies
    |> cast(attrs, [:tmdb_id, :title, :overview, :year, :poster, :background, :path])
    |> validate_required([:tmdb_id])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:tmdb_id]) do
      {:ok, record} ->

        MediaServer.Workers.AddMovieGenres.new(%{"id" => record.id}) |> Oban.insert()

        # MediaServer.Workers.AddPeople.new(%{"id" => record.id}) |> Oban.insert()

        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
