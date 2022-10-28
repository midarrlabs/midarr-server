defmodule MediaServer.Accounts.UserMedia do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "media" do
    field :media_id, :integer

    belongs_to :media_type, MediaServer.MediaTypes

    timestamps()
  end

  def changeset(continue, attrs) do
    continue
    |> cast(attrs, [:media_id, :media_type_id])
    |> validate_required([:media_id, :media_type_id])
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
