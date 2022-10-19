defmodule MediaServer.Episodes.Action do
  use Ecto.Schema
  import Ecto.Changeset

  schema "episode_actions" do
    field :episode_id, :integer
    field :serie_id, :integer
    field :title, :string
    field :user_id, :id
    field :user_action_id, :id

    timestamps()
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:episode_id, :serie_id, :title, :user_id, :user_action_id])
    |> validate_required([:episode_id, :serie_id, :title, :user_id, :user_action_id])
  end
end
