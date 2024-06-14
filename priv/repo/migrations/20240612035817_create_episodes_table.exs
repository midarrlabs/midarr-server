defmodule MediaServer.Repo.Migrations.CreateEpisodesTable do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add :series_id, references(:series, on_delete: :nothing), null: false
      add :external_id, :integer, null: false

      timestamps()
    end

    create unique_index(:episodes, [:external_id])
  end
end
