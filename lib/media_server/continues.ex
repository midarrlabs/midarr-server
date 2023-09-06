defmodule MediaServer.Continues do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "continues" do
    field :media_id, :integer

    field :current_time, :integer
    field :duration, :integer

    belongs_to :user, MediaServer.Accounts.User
    belongs_to :media_type, MediaServer.MediaTypes

    timestamps()
  end

  def changeset(continue, attrs) do
    continue
    |> cast(attrs, [:media_id, :current_time, :duration, :user_id, :media_type_id])
    |> validate_required([:media_id, :current_time, :duration, :user_id, :media_type_id])
  end

  def insert_or_update(attrs) do
    case Repo.get_by(__MODULE__,
           media_id: attrs.media_id,
           user_id: attrs.user_id,
           media_type_id: attrs.media_type_id
         ) do
      nil ->
        %__MODULE__{
          media_id: attrs.media_id,
          user_id: attrs.user_id,
          media_type_id: attrs.media_type_id
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

  def where(attrs) do
    Repo.get_by(__MODULE__, attrs)
  end
end
