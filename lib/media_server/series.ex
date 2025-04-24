defmodule MediaServer.Series do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :seasons, :title, :overview, :year, :poster, :background]
  }

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
    field :year, :integer
    field :poster, :string
    field :background, :string

    has_many :episodes, MediaServer.Episodes

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:sonarr_id, :tmdb_id, :seasons, :title, :overview, :year, :poster, :background])
    |> validate_required([:sonarr_id])
  end

  def insert(attrs) do
    changeset = changeset(attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:sonarr_id]) do
      {:ok, record} ->

        MediaServer.AddSeasons.new(%{"id" => record.id, "sonarr_id" => record.sonarr_id}) |> Oban.insert()

        MediaServer.AddEpisodes.new(%{"id" => record.id, "sonarr_id" => record.sonarr_id}) |> Oban.insert()

        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
