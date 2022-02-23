defmodule MediaServer.Repo.Migrations.CreateEpisodeWatchStatuses do
  use Ecto.Migration

  def change do
    create table(:episode_watch_statuses) do
      add :episode_id, :integer, null: false
      add :serie_id, :integer, null: false
      add :title, :string, null: false
      add :image_url, :string
      add :current_time, :integer, null: false
      add :duration, :integer, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:episode_watch_statuses, [:user_id])
  end
end
