defmodule MediaServer.Movies do
  use Ecto.Schema
  import Ecto.Changeset

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
    field :poster, :string
    field :background, :string

    has_one :continue, MediaServer.MovieContinues, foreign_key: :movies_id

    timestamps()
  end

  def changeset(movies, attrs) do
    movies
    |> cast(attrs, [:radarr_id, :tmdb_id, :title, :overview, :poster, :background])
    |> validate_required([:radarr_id])
  end

  def insert(attrs) do
    record = MediaServer.Repo.get_by(__MODULE__, radarr_id: attrs.radarr_id)

    record = case record do
      nil -> %__MODULE__{
        radarr_id: attrs.radarr_id,
        tmdb_id: attrs.tmdb_id,
        title: attrs.title,
        overview: attrs.overview,
        poster: attrs.poster,
        background: attrs.background
      }
      _existing_record -> record
    end

    record
    |> changeset(attrs)
    |> MediaServer.Repo.insert_or_update!()
  end
end
