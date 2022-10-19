defmodule MediaServer.Repo.Migrations.CreateEpisodeActions do
  use Ecto.Migration

  def change do
    create table(:episode_actions) do
      add :episode_id, :integer
      add :serie_id, :integer
      add :title, :string

      add :user_id, references(:users, on_delete: :nothing)
      add :user_action_id, references(:user_actions, on_delete: :nothing)

      timestamps()
    end
  end
end
