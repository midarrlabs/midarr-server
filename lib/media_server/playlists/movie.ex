defmodule MediaServer.Playlists.Movie do
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
    |> cast(attrs, [:movie_id, :title, :image_url])
    |> validate_required([:movie_id, :title, :image_url])
  end
end
