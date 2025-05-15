defmodule MediaServer.Repo.Migrations.CreateGenresTable do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :tmdb_id, :integer, null: false
      add :name, :string

      timestamps()
    end

    create unique_index(:genres, [:tmdb_id])
  end
end
