defmodule MediaServer.Repo.Migrations.CreateMovieFavourites do
  use Ecto.Migration

  def change do
    create table(:movie_favourites) do
      add :movie_id, :integer, null: false
      add :title, :string, null: false
      add :image_url, :string
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:movie_favourites, [:user_id])
  end
end
