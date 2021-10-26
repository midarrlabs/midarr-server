defmodule MediaServer.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field :name, :string
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :path])
    |> validate_required([:name, :path])
  end
end
