defmodule MediaServer.MediaAudio do
  use Ecto.Schema
  import Ecto.Changeset

  schema "media_audio" do
    belongs_to :media, MediaServer.Media

    field :duration, :decimal

    timestamps()
  end

  def changeset(record, attrs) do
    record
    |> cast(attrs, [:media_id, :duration])
    |> validate_required([:media_id, :duration])
    |> unique_constraint(:media_id)
  end

  def insert_record(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:media_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
