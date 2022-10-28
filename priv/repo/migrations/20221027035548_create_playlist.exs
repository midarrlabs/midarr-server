defmodule MediaServer.Repo.Migrations.CreatePlaylist do
  use Ecto.Migration

  def change do
    create table(:playlist) do
      add :name, :string

      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
