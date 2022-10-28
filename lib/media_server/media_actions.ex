defmodule MediaServer.MediaActions do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "media_actions" do
    belongs_to :user, MediaServer.Accounts.User
    belongs_to :media, MediaServer.Media
    belongs_to :action, MediaServer.Actions

    timestamps()
  end

  def changeset(continue, attrs) do
    continue
    |> cast(attrs, [:user_id, :media_id, :action_id])
    |> validate_required([:user_id, :media_id, :action_id])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def all do
    Repo.all(__MODULE__)
  end

  def get(id) do
    Repo.get!(__MODULE__, id)
  end
end
