defmodule MediaServer.Repo.Migrations.CreateMovieActions do
  use Ecto.Migration

  def change do
    create table(:movie_actions) do
      add :movie_id, :integer, null: false
      add :title, :string, null: false

      add :user_id, references(:users, on_delete: :nothing), null: false
      add :user_action_id, references(:user_actions, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
