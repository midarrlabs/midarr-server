defmodule MediaServer.Repo.Migrations.CreateSonarrs do
  use Ecto.Migration

  def change do
    create table(:sonarrs) do
      add :name, :string
      add :url, :string
      add :api_key, :string

      timestamps()
    end
  end
end
