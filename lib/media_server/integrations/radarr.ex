defmodule MediaServer.Integrations.Radarr do
  use Ecto.Schema
  import Ecto.Changeset

  schema "radarrs" do
    field :api_key, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(radarr, attrs) do
    radarr
    |> cast(attrs, [:name, :url, :api_key])
    |> validate_required([:name, :url, :api_key])
  end
end
