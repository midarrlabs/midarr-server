defmodule MediaServer.Movies do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :external_id, :integer

    has_one :continue, MediaServer.MovieContinues, foreign_key: :movies_id

    timestamps()
  end

  def changeset(movies, attrs) do
    movies
    |> cast(attrs, [:external_id])
    |> validate_required([:external_id])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:external_id]) do
      {:ok, record} ->

        MediaServer.AddPeople.new(%{"items" => MediaServerWeb.Repositories.Movies.get_cast(record.external_id)
          |> Enum.map(fn x ->  %{"tmdb_id" => x["personTmdbId"]} end)}
          )|> Oban.insert()

        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
