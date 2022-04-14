defmodule MediaServer.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:actions, [:name])
  end
end
