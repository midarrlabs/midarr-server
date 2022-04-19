defmodule MediaServer.Repo.Migrations.CreateEpisodeActions do
  use Ecto.Migration

  def change do
    create table(:episode_actions) do
      add :episode_id, :integer
      add :serie_id, :integer
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :action_id, references(:actions, on_delete: :nothing)

      timestamps()
    end

    create index(:episode_actions, [:user_id])
    create index(:episode_actions, [:action_id])
  end
end
