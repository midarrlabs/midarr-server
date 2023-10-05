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

  def get_played_id() do
    Repo.get_by!(__MODULE__, action: "played").id
  end

  def get_followed_id() do
    Repo.get_by!(__MODULE__, action: "followed").id
  end
end
