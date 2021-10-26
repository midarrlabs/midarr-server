defmodule MediaServer.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add :name, :string
      add :path, :string

      timestamps()
    end
  end
end
