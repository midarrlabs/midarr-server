defmodule MediaServer.MediaTypes do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "media_types" do
    field :type, :string
  end

  def changeset(media_types, attrs) do
    media_types
    |> cast(attrs, [:type])
    |> validate_required([:type])
    |> unique_constraint(:type)
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> Repo.insert()
  end

  def get_movie_id() do
    Repo.get_by!(__MODULE__, type: "movie").id
  end

  def get_episode_id() do
    Repo.get_by!(__MODULE__, type: "episode").id
  end
end
