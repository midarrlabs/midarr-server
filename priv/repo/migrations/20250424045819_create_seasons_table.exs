defmodule MediaServer.Repo.Migrations.CreateSeasonsTable do
  use Ecto.Migration

  def change do
    create table(:seasons) do
      add :series_id, references(:series, on_delete: :nothing), null: false
      add :number, :integer, null: false
      add :poster, :string

      timestamps()
    end

    create unique_index(:seasons, [:series_id, :number])
  end
end
