defmodule MediaServer.Repo.Migrations.CreateMoviesTable do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :tmdb_id, :integer
      add :title, :string
      add :overview, :text
      add :year, :integer
      add :poster, :string
      add :background, :string
      add :path, :string

      timestamps()
    end

    create unique_index(:movies, [:tmdb_id])
  end
end
