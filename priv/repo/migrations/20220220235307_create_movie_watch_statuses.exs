defmodule MediaServer.Repo.Migrations.CreateMovieWatchStatuses do
  use Ecto.Migration

  def change do
    create table(:movie_watch_statuses) do
      add :movie_id, :integer, null: false
      add :timestamp, :integer, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:movie_watch_statuses, [:user_id])
  end
end
