defmodule MediaServer.Episodes.Continue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "episode_continues" do
    field :current_time, :integer
    field :duration, :integer
    field :episode_id, :integer
    field :image_url, :string
    field :serie_id, :integer
    field :title, :string
    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [
      :episode_id,
      :serie_id,
      :title,
      :image_url,
      :current_time,
      :duration,
      :user_id
    ])
    |> validate_required([:episode_id, :serie_id, :title, :current_time, :duration, :user_id])
  end
end
