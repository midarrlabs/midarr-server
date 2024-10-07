defmodule MediaServer.People do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name],
    sortable: [:id]
  }

  schema "people" do
    field :tmdb_id, :integer
    field :name, :string
    field :image, :string

    timestamps()
  end

  def changeset(record, attrs) do
    record
    |> cast(attrs, [:tmdb_id, :name, :image])
    |> validate_required([:tmdb_id, :name, :image])
  end

  def insert(attrs) do
    record = MediaServer.Repo.get_by(__MODULE__, tmdb_id: attrs.tmdb_id)

    record = case record do
      nil -> %__MODULE__{
        tmdb_id: attrs.tmdb_id,
        name: attrs.name,
        image: attrs.image
      }
      _existing_record -> record
    end

    record
    |> changeset(attrs)
    |> MediaServer.Repo.insert_or_update()
  end
end
