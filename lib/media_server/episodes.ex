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

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:series_id, :sonarr_id, :season, :number, :title, :overview, :screenshot])
    |> validate_required([:series_id, :sonarr_id, :season, :number])
  end

  def insert(attrs) do
    changeset = changeset(attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:sonarr_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
