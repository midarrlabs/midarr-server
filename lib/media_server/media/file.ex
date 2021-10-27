defmodule MediaServer.Media.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :name, :string

    belongs_to :library, MediaServer.Media.Library

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
