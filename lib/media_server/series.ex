defmodule MediaServer.Series do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [],
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

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:sonarr_id, :tmdb_id, :seasons, :title, :overview, :poster, :background])
    |> validate_required([:sonarr_id, :tmdb_id])
  end

  def insert(attrs) do
    changeset = changeset(attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:sonarr_id]) do
      {:ok, record} ->

        MediaServer.AddEpisode.new(%{"items" => MediaServerWeb.Repositories.Episodes.get_all(record.sonarr_id)
        |> Enum.map(fn item ->  %{
            "series_id" => record.id,
            "sonarr_id" => item["id"],
            "season" => item["seasonNumber"],
            "number" => item["episodeNumber"],
            "title" => item["title"],
            "overview" => item["overview"],
            "screenshot" => MediaServerWeb.Repositories.Episodes.get_screenshot(item),
          }
        end)})
        |> Oban.insert()

        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
