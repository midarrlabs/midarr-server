defmodule MediaServer.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :path, :string

      add :library_id, references(:libraries, on_delete: :delete_all)
      timestamps()
    end
  end
end
