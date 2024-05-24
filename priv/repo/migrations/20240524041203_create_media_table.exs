defmodule MediaServer.Repo.Migrations.CreateMediaTable do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :media_type_id, references(:media_types, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
