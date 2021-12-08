defmodule MediaServer.Repo.Migrations.AddPosterColumnToFilesTable do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :poster, :string
    end
  end
end
