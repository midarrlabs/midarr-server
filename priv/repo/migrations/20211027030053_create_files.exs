defmodule MediaServer.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string

      add :library_id, references(:libraries)
      timestamps()
    end
  end
end
