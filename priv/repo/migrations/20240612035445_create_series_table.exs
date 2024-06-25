defmodule MediaServer.Repo.Migrations.CreateSeriesTable do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :sonarr_id, :integer, null: false
      add :tmdb_id, :integer, null: false
      add :seasons, :integer, null: false
      add :title, :string
      add :overview, :text
      add :poster, :string
      add :background, :string

      timestamps()
    end

    create unique_index(:series, [:sonarr_id])
  end
end
