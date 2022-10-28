defmodule MediaServer.MediaTypes do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "media_types" do
    field :type, :string
  end

  def changeset(media_types, attrs) do
    media_types
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> Repo.insert()
  end

  def get_id(type) do
    Repo.get_by!(__MODULE__, type: type).id
  end
end
