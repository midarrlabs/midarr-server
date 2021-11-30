defmodule MediaServer.Repo.Migrations.AddYearColumnToFilesTable do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :year, :integer
    end
  end
end
