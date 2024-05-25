defmodule MediaServer.Actions do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "actions" do
    field :label, :string
  end

  def changeset(action, attrs) do
    action
    |> cast(attrs, [:label])
    |> validate_required([:label])
    |> unique_constraint(:label)
  end

  def all do
    Repo.all(__MODULE__)
  end

  def get_played_id() do
    Repo.get_by!(__MODULE__, label: "played").id
  end

  def get_followed_id() do
    Repo.get_by!(__MODULE__, label: "followed").id
  end
end
