defmodule MediaServer.Repo.Migrations.CreateMoviesTable do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :external_id, :integer, null: false

      timestamps()
    end

    create unique_index(:movies, [:external_id])
  end
end
