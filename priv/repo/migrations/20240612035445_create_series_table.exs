defmodule MediaServer.Repo.Migrations.CreateSeriesTable do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :external_id, :integer, null: false

      timestamps()
    end

    create unique_index(:series, [:external_id])
  end
end
