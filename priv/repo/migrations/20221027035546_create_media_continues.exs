defmodule MediaServer.Repo.Migrations.CreateMediaContinues do
  use Ecto.Migration

  def change do
    create table(:media_continues) do
      add :media_id, :integer, null: false

      add :current_time, :integer, null: false
      add :duration, :integer, null: false

      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
