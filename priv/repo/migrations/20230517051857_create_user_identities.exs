defmodule MediaServer.Repo.Migrations.CreateUserIdentities do
  use Ecto.Migration

  def change do
    create table(:user_identities) do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :user_id, references("users", on_delete: :nothing)

      timestamps()
    end

    create unique_index(:user_identities, [:uid, :provider])
  end
end
