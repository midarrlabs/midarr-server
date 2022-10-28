defmodule MediaServer.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "playlist" do
    field :name, :string

    belongs_to :user, MediaServer.Accounts.User
    has_many :playlist_media, MediaServer.PlaylistMedia

    timestamps()
  end

  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
