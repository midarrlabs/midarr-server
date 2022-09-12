defmodule MediaServer.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlists" do
    field :name, :string
    field :can_delete, :boolean, default: true
    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :can_delete, :user_id])
    |> validate_required([:name, :can_delete, :user_id])
  end
end
