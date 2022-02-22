defmodule MediaServer.WatchStatuses.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_watch_statuses" do
    field :movie_id, :integer
    field :title, :string
    field :image_url, :string
    field :current_time, :integer
    field :duration, :integer
    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :title, :image_url, :current_time, :duration, :user_id])
    |> validate_required([:movie_id, :title, :current_time, :duration, :user_id])
  end
end
