defmodule MediaServer.Repo.Migrations.CreatePlaylists do
  use Ecto.Migration

  def change do
    create table(:playlists) do
      add :name, :string

      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
