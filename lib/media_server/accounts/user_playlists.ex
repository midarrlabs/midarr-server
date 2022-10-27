defmodule MediaServer.Accounts.UserPlaylists do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_playlists" do
    field :name, :string

    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
