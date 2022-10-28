defmodule MediaServer.Actions do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "actions" do
    field :action, :string
  end

  def changeset(action, attrs) do
    action
    |> cast(attrs, [:action])
    |> validate_required([:action])
    |> unique_constraint(:action)
  end

  def all do
    Repo.all(__MODULE__)
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> Repo.insert()
  end
end
