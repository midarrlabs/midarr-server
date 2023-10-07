defmodule MediaServer.PushSubscriptions do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "push_subscriptions" do
    field :push_subscription, :string

    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  def changeset(media_actions, attrs) do
    media_actions
    |> cast(attrs, [:push_subscription, :user_id])
    |> validate_required([:push_subscription, :user_id])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def all do
    Repo.all(__MODULE__)
  end

  def where(attrs) do
    Repo.get_by(__MODULE__, attrs)
  end

  def delete(attrs) do
    Repo.get_by(__MODULE__, attrs)
    |> Repo.delete
  end
end
