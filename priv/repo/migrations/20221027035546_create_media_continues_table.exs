defmodule MediaServer.Repo.Migrations.CreateMediaContinuesTable do
  use Ecto.Migration

  def change do
    create table(:media_continues) do
      add :media_id, references(:media, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      add :current_time, :integer, null: false
      add :duration, :integer, null: false

      timestamps()
    end
  end
end
