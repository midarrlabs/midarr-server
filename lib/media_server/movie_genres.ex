defmodule MediaServer.MovieGenres do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_genres" do
    belongs_to :movie, MediaServer.Movies, foreign_key: :movies_id
    belongs_to :genre, MediaServer.Genres, foreign_key: :genres_id
  end

  def changeset(people, attrs) do
    people
    |> cast(attrs, [:movies_id, :genres_id])
    |> validate_required([:movies_id, :genres_id])
  end

  def insert(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: [set: [movies_id: Ecto.Changeset.get_field(changeset, :movies_id), genres_id: Ecto.Changeset.get_field(changeset, :genres_id)]], conflict_target: [:movies_id, :genres_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
