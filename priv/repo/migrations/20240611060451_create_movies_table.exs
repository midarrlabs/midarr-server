defmodule MediaServer.Repo.Migrations.CreateMoviesTable do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :radarr_id, :integer, null: false
      add :tmdb_id, :integer
      add :title, :string
      add :overview, :text
      add :year, :integer
      add :poster, :string
      add :background, :string

      timestamps()
    end

    create unique_index(:movies, [:radarr_id])
  end
end
