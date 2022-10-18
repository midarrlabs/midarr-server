defmodule MediaServer.Action do
  use Ecto.Schema
  import Ecto.Changeset

  schema "actions" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
