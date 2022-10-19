defmodule MediaServer.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:user_actions) do
      add :action, :string, null: false

      timestamps()
    end
  end
end
