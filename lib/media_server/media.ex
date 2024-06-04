defmodule MediaServer.Media do
  use Ecto.Schema
  import Ecto.Changeset

  schema "media" do
    belongs_to :type, MediaServer.Types

    field :external_id, :integer

    timestamps()
  end

  def changeset(media, attrs) do
    media
    |> cast(attrs, [:type_id, :external_id])
    |> validate_required([:type_id, :external_id])
  end

  def insert_record(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:type_id, :external_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
