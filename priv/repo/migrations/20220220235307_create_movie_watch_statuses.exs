defmodule MediaServer.Repo.Migrations.CreateMovieWatchStatuses do
  use Ecto.Migration

  def change do
    create table(:movie_watch_statuses) do
      add :movie_id, :integer
      add :timestamp, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:movie_watch_statuses, [:user_id])
  end
end
