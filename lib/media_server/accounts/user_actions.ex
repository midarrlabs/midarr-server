defmodule MediaServer.Action do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_actions" do
    field :action, :string

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:action])
    |> validate_required([:action])
    |> unique_constraint(:action)
  end
end
