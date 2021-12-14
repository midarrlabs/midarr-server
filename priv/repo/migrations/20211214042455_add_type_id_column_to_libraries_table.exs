defmodule MediaServer.Repo.Migrations.AddTypeIdColumnToLibrariesTable do
  use Ecto.Migration

  def change do
    alter table(:libraries) do
      add :type_id, references(:types, on_delete: :delete_all)
    end
  end
end
