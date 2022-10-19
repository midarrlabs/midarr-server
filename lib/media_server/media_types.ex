defmodule MediaServer.MediaTypes do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "media_types" do
    field :type, :string

    timestamps()
  end

  def changeset(media_type, attrs) do
    media_type
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> Repo.insert()
  end
end
