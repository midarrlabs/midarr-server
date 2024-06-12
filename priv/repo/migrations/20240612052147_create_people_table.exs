defmodule MediaServer.Repo.Migrations.CreatePeopleTable do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :tmdb_id, :integer, null: false

      timestamps()
    end

    create unique_index(:people, [:tmdb_id])
  end
end
