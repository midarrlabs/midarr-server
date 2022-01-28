defmodule MediaServer.Repo.Migrations.AddIsAdminColumnToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean
    end
  end
end
