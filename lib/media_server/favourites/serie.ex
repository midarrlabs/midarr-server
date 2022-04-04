defmodule MediaServer.Favourites.Serie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "serie_favourites" do
    field :serie_id, :integer
    field :title, :string
    field :image_url, :string
    belongs_to :user, MediaServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(serie, attrs) do
    serie
    |> cast(attrs, [:serie_id, :title, :image_url, :user_id])
    |> validate_required([:serie_id, :title, :user_id])
  end
end
