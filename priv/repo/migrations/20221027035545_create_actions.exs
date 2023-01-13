defmodule MediaServer.Repo.Migrations.Actions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :action, :string, null: false
    end

    create unique_index(:actions, [:action])
  end
end
