defmodule MediaServer.Movies.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlist_movies" do
    field :image_url, :string
    field :movie_id, :integer
    field :title, :string

    belongs_to :playlist, MediaServer.Playlists.Playlist

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :title, :image_url, :playlist_id])
    |> validate_required([:movie_id, :title, :image_url, :playlist_id])
  end
end
