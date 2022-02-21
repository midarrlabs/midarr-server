defmodule MediaServer.WatchStatuses.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_watch_statuses" do
    field :movie_id, :integer
    field :timestamp, :integer
    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :timestamp, :user_id])
    |> validate_required([:movie_id, :timestamp, :user_id])
  end
end
