defmodule MediaServer.Repo.Migrations.CreateMediaTable do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :type_id, references(:types, on_delete: :nothing), null: false

      add :external_id, :integer, null: false

      timestamps()
    end
  end
end
