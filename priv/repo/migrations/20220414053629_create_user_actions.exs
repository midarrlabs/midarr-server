defmodule MediaServer.Repo.Migrations.CreateUserActions do
  use Ecto.Migration

  def change do
    create table(:user_actions) do
      add :action, :string, null: false

      timestamps()
    end

    create unique_index(:user_actions, [:action])
  end
end
