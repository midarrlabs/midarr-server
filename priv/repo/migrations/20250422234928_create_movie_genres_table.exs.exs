defmodule MediaServer.Repo.Migrations.CreateMovieGenresTable do
  use Ecto.Migration

  def change do
    create table(:movie_genres) do
      add :movies_id, references(:movies, on_delete: :nothing), null: false
      add :genres_id, references(:genres, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:movie_genres, [:movies_id, :genres_id])
  end
end
