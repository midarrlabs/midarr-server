defmodule MediaServer.Media.Type do
  use Ecto.Schema
  import Ecto.Changeset

  schema "types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> unique_constraint(:name, name: :types_name_index)
    |> validate_required([:name])
  end
end
