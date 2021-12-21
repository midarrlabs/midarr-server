defmodule MediaServer.Providers.Sonarr do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sonarrs" do
    field :api_key, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(sonarr, attrs) do
    sonarr
    |> cast(attrs, [:name, :url, :api_key])
    |> validate_required([:name, :url, :api_key])
  end
end
