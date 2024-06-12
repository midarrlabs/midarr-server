defmodule MediaServer.Repo.Migrations.CreateContinuesTable do
  use Ecto.Migration

  def change do
    create table(:movie_continues) do
      add :movie_id, references(:movies, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      add :current_time, :integer, null: false
      add :duration, :integer, null: false

      timestamps()
    end
  end
end
