defmodule MediaServer.Repo.Migrations.CreatePlaylistMedia do
  use Ecto.Migration

  def change do
    create table(:playlist_media) do
      add :media_id, :integer, null: false

      add :playlists_id, references(:playlists, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
