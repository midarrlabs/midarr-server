defmodule MediaServer.Repo.Migrations.CreateEpisodeContinuesTable do
  use Ecto.Migration

  def change do
    create table(:episode_continues) do
      add :episodes_id, references(:episodes, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      add :current_time, :integer, null: false
      add :duration, :integer, null: false

      timestamps()
    end
  end
end
