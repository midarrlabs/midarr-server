defmodule MediaServer.Accounts.UserContinues do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "user_continues" do
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

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> Repo.insert()
  end
end
