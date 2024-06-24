defmodule MediaServer.Series do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:id]
  }

  schema "series" do
    field :external_id, :integer

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:external_id])
    |> validate_required([:external_id])
  end

  def insert(attrs) do
    changeset = changeset(attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:external_id]) do
      {:ok, record} ->

        MediaServer.AddEpisode.new(%{"items" => MediaServerWeb.Repositories.Episodes.get_all(record.external_id)
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
