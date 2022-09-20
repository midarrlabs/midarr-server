defmodule MediaServer.Repo.Migrations.CreatePlaylistMovies do
  use Ecto.Migration

  def change do
    create table(:playlist_movies) do
      add :movie_id, :integer, null: false
      add :title, :string, null: false
      add :image_url, :string
      add :playlist_id, references(:playlists, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:playlist_movies, [:playlist_id])
  end
end
