defmodule MediaServer.Favourites.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_favourites" do
    field :movie_id, :integer
    field :title, :string
    field :image_url, :string
    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :title, :image_url, :user_id])
    |> validate_required([:movie_id, :title, :user_id])
  end
end
