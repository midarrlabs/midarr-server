defmodule MediaServer.Repo.Migrations.CreateRadarrs do
  use Ecto.Migration

  def change do
    create table(:radarrs) do
      add :name, :string
      add :url, :string
      add :api_key, :string

      timestamps()
    end
  end
end
