defmodule MediaServer.Repo.Migrations.CreateMediaActionsTable do
  use Ecto.Migration

  def change do
    create table(:media_actions) do
      add :media_id, references(:media, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :action_id, references(:actions, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
