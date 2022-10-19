defmodule MediaServer.Movies.Action do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_actions" do
    field :movie_id, :integer
    field :title, :string
    field :user_id, :id
    field :user_action_id, :id

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :title, :user_id, :user_action_id])
    |> validate_required([:movie_id, :title, :user_id, :user_action_id])
  end
end
