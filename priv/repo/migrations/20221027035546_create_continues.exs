defmodule MediaServer.Repo.Migrations.CreateContinues do
  use Ecto.Migration

  def change do
    create table(:continues) do
      add :current_time, :integer, null: false
      add :duration, :integer, null: false

      add :user_id, references(:users, on_delete: :nothing), null: false
      add :media_id, references(:media, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
