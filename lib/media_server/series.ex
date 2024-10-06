defmodule MediaServer.Series do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title],
    sortable: [:id, :title]
  }

  schema "series" do
    field :sonarr_id, :integer
    field :tmdb_id, :integer
    field :seasons, :integer
    field :title, :string
    field :overview, :string
    field :poster, :string
    field :background, :string

    has_many :episodes, MediaServer.Episodes

    timestamps()
  end

  def changeset(record = %__MODULE__{}, attrs) do
    record
    |> cast(attrs, [:sonarr_id, :tmdb_id, :seasons, :title, :overview, :poster, :background])
    |> validate_required([:sonarr_id])
  end

  def insert(attrs) do
    record = MediaServer.Repo.get_by(__MODULE__, sonarr_id: attrs.sonarr_id)

    record = case record do
      nil -> %__MODULE__{
        sonarr_id: attrs.sonarr_id,
        tmdb_id: attrs.tmdb_id,
        seasons: attrs.seasons,
        title: attrs.title,
        overview: attrs.overview,
        poster: attrs.poster,
        background: attrs.background
      }
      _existing_record -> record
    end

    record
    |> changeset(attrs)
    |> MediaServer.Repo.insert_or_update()
  end
end
