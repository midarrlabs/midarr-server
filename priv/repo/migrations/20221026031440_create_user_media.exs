defmodule MediaServer.Repo.Migrations.CreateUserMedia do
  use Ecto.Migration

  def change do
    create table(:user_media) do
      add :media_id, :integer, null: false

      add :media_type_id, references(:media_types, on_delete: :nothing), null: false

      add :user_id, references(:users, on_delete: :nothing), null: false
      add :user_action_id, references(:user_actions, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
