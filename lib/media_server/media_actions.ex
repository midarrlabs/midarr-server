defmodule MediaServer.MediaActions do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias MediaServer.Repo

  schema "media_actions" do
    belongs_to :media, MediaServer.Media
    belongs_to :user, MediaServer.Accounts.User
    belongs_to :action, MediaServer.Actions

    timestamps()
  end

  def changeset(media_actions, attrs) do
    media_actions
    |> cast(attrs, [:media_id, :user_id, :action_id, :updated_at])
    |> validate_required([:media_id, :user_id, :action_id])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def insert_or_update(attrs) do
    case Repo.get_by(__MODULE__, attrs) do
      nil ->
        %__MODULE__{
          media_id: attrs.media_id,
          user_id: attrs.user_id,
          action_id: attrs.action_id
        }

      item ->
        item
    end
    |> changeset(
      Enum.into(attrs, %{
        updated_at: DateTime.utc_now()
      })
    )
    |> Repo.insert_or_update()
  end

  def all do
    Repo.all(__MODULE__)
  end

  def where(attrs) do
    Repo.get_by(__MODULE__, attrs)
  end

  def delete(attrs) do
    Repo.get_by(__MODULE__, attrs)
    |> Repo.delete()
  end

  def movie(id) do
    from this in __MODULE__,
      where: this.media_id == ^id
  end

  def series(id) do
    from this in __MODULE__,
      where: this.media_id == ^id
  end

  def followers(query) do
    MediaServer.Repo.all(
      from this in query,
        where: this.action_id == ^MediaServer.Actions.get_followed_id(),
        preload: [user: [:push_subscriptions]]
    )
  end
end
