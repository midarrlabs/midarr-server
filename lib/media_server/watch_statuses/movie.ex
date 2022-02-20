defmodule MediaServer.WatchStatuses.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_watch_statuses" do
    field :movie_id, :integer
    field :timestamp, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :timestamp])
    |> validate_required([:movie_id, :timestamp])
  end
end
