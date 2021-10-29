defmodule MediaServer.Media.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :path, :string

    belongs_to :library, MediaServer.Media.Library

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:path, :library_id])
    |> validate_required([:path, :library_id])
    |> assoc_constraint(:library)
  end
end
