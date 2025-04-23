defmodule MediaServer.Movies do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :title, :overview, :year, :poster, :background]
  }

  @derive {
    Flop.Schema,
    filterable: [:title],
    sortable: [:id, :title]
  }

  schema "movies" do
    field :radarr_id, :integer
    field :tmdb_id, :integer
    field :title, :string
    field :overview, :string
    field :year, :integer
    field :poster, :string
    field :background, :string

    has_one :continue, MediaServer.MovieContinues, foreign_key: :movies_id
    many_to_many :genres, MediaServer.Genres, join_through: "movie_genres"

    timestamps()
  end

  def changeset(movies, attrs) do
    movies
    |> cast(attrs, [:radarr_id, :tmdb_id, :title, :overview, :year, :poster, :background])
    |> validate_required([:radarr_id])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:radarr_id]) do
      {:ok, record} ->

        MediaServer.AddMovieGenres.new(%{"id" => record.id}) |> Oban.insert()

        MediaServer.AddPeople.new(%{"items" => MediaServerWeb.Repositories.Movies.get_cast(record.radarr_id)
          |> Enum.map(fn item ->  %{
            tmdb_id: item["personTmdbId"],
            name: item["personName"],
            image: MediaServer.Helpers.get_headshot(item)}
          end)}
          )|> Oban.insert()

        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
