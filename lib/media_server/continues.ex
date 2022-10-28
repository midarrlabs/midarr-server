defmodule MediaServer.Accounts.UserContinues do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "continues" do
    field :current_time, :integer
    field :duration, :integer

    belongs_to :user, MediaServer.Accounts.User
    belongs_to :media, MediaServer.Media

    timestamps()
  end

  def changeset(continue, attrs) do
    continue
    |> cast(attrs, [:current_time, :duration, :user_id, :media_id])
    |> validate_required([:current_time, :duration, :user_id, :media_id])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def find(id) do
    Repo.get!(__MODULE__, id)
  end

  def delete(id) do
    find(id)
    |> Repo.delete()
  end

  def update(id, attrs) do
    find(id)
    |> changeset(attrs)
    |> Repo.update()
  end

  def update_or_create(attrs) do
    continue = Repo.get_by(__MODULE__, media_id: attrs.media_id, user_id: attrs.user_id)

    case continue do
      nil ->
        if attrs.current_time / attrs.duration * 100 < 90 do
          create(attrs)
        else
          nil
        end

      _ ->
        if attrs.current_time / attrs.duration * 100 < 90 do
          update(continue.id, attrs)
        else
          delete(continue.id)

          nil
        end
    end
  end
end
