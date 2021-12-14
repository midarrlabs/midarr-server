defmodule MediaServer.Media.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field :name, :string
    field :path, :string

    has_many :files, MediaServer.Media.File
    belongs_to :type, MediaServer.Media.Type

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :path, :type_id])
    |> validate_required([:name, :path, :type_id])
    |> assoc_constraint(:type)
  end
end
