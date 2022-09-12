defmodule MediaServer.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlists" do
    field :can_delete, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :can_delete])
    |> validate_required([:name, :can_delete])
  end
end
