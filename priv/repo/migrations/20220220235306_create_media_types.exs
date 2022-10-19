defmodule MediaServer.Repo.Migrations.CreateMediaTypes do
  use Ecto.Migration

  def change do
    create table(:media_types) do
      add :type, :string, null: false

      timestamps()
    end

    create unique_index(:media_types, [:type])
  end
end
