defmodule MediaServer.Repo.Migrations.CreateMovieActions do
  use Ecto.Migration

  def change do
    create table(:movie_actions) do
      add :movie_id, :integer, null: false
      add :title, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :action_id, references(:actions, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:movie_actions, [:user_id])
    create index(:movie_actions, [:action_id])
  end
end
