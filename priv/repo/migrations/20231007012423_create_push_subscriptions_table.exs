defmodule MediaServer.Repo.Migrations.CreatePushSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table(:push_subscriptions) do
      add :push_subscription, :text, null: false

      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
