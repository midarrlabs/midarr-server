defmodule MediaServer.Repo.Migrations.CreateMovieWatches do
  use Ecto.Migration

  def change do
    create table(:movie_watches) do
      add :movie_id, :integer, null: false
      add :title, :string, null: false
      add :image_url, :string
      add :current_time, :integer, null: false
      add :duration, :integer, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:movie_watches, [:user_id])
  end
end
