defmodule MediaServer.Episodes do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:number]
  }

  schema "episodes" do
    field :sonarr_id, :integer
    field :season, :integer
    field :number, :integer
    field :title, :string
    field :overview, :string
    field :screenshot, :string

    belongs_to :series, MediaServer.Series, foreign_key: :series_id
    has_one :continue, MediaServer.EpisodeContinues, foreign_key: :episodes_id

    timestamps()
  end

  def changeset(record = %__MODULE__{}, attrs) do
    record
    |> cast(attrs, [:series_id, :sonarr_id, :season, :number, :title, :overview, :screenshot])
    |> validate_required([:series_id, :sonarr_id, :season, :number])
  end

  def insert(attrs) do
    record = MediaServer.Repo.get_by(__MODULE__, sonarr_id: attrs.sonarr_id)

    record = case record do
      nil -> %__MODULE__{
        sonarr_id: attrs.sonarr_id,
        season: attrs.season,
        number: attrs.number,
        title: attrs.title,
        overview: attrs.overview,
        screenshot: attrs.screenshot
      }
      _existing_record -> record
    end

    record
    |> changeset(attrs)
    |> MediaServer.Repo.insert_or_update()
  end
end
