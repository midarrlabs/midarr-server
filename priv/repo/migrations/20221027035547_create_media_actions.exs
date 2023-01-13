defmodule MediaServer.Repo.Migrations.CreateMediaActions do
  use Ecto.Migration

  def change do
    create table(:media_actions) do
      add :media_id, :integer, null: false

      add :user_id, references(:users, on_delete: :nothing), null: false
      add :media_type_id, references(:media_types, on_delete: :nothing), null: false
      add :action_id, references(:actions, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
