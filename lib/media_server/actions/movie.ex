defmodule MediaServer.Actions.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_actions" do
    field :movie_id, :integer
    field :title, :string
    field :user_id, :id
    field :action_id, :id

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :title, :user_id, :action_id])
    |> validate_required([:movie_id, :title, :user_id, :action_id])
  end
end
