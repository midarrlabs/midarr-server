defmodule MediaServer.Repo.Migrations.CreateSerieFavourites do
  use Ecto.Migration

  def change do
    create table(:serie_favourites) do
      add :serie_id, :integer, null: false
      add :title, :string, null: false
      add :image_url, :string
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:serie_favourites, [:user_id])
  end
end
