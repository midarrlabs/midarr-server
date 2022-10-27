defmodule MediaServer.Media do
  use Ecto.Schema
  import Ecto.Changeset

  schema "media" do
    field :media_id, :integer

    belongs_to :media_type, MediaServer.MediaTypes

    timestamps()
  end

  def changeset(media, attrs) do
    media
    |> cast(attrs, [:media_id, :media_type_id])
    |> validate_required([:media_id, :media_type_id])
  end
end
