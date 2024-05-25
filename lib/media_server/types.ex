defmodule MediaServer.Types do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "types" do
    field :label, :string
  end

  def changeset(type, attrs) do
    type
    |> cast(attrs, [:label])
    |> validate_required([:label])
    |> unique_constraint(:label)
  end

  def get_movie_id() do
    Repo.get_by!(__MODULE__, label: "movie").id
  end

  def get_series_id() do
    Repo.get_by!(__MODULE__, label: "series").id
  end

  def get_episode_id() do
    Repo.get_by!(__MODULE__, label: "episode").id
  end

  def get_type_id(type) do
    Repo.get_by!(__MODULE__, label: type).id
  end
end
