defmodule MediaServer.Repo.Migrations.CreateActionsTable do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :label, :string, null: false
    end

    create unique_index(:actions, [:label])
  end
end
