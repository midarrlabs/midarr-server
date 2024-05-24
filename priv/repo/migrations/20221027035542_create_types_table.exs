defmodule MediaServer.Repo.Migrations.CreateTypesTable do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :label, :string, null: false
    end

    create unique_index(:types, [:label])
  end
end
