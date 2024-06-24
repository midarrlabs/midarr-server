defmodule MediaServer.Repo.Migrations.CreateEpisodesTable do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add :series_id, references(:series, on_delete: :nothing), null: false
      add :sonarr_id, :integer, null: false
      add :season, :integer, null: false
      add :number, :integer, null: false
      add :title, :string
      add :overview, :text
      add :screenshot, :string

      timestamps()
    end

    create unique_index(:episodes, [:sonarr_id])
  end
end
