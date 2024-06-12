defmodule MediaServer.Episodes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "episodes" do
    field :external_id, :integer

    belongs_to :series, MediaServer.Series, foreign_key: :series_id
    has_one :continue, MediaServer.EpisodeContinues, foreign_key: :episodes_id

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:series_id, :external_id])
    |> validate_required([:series_id, :external_id])
  end

  def insert(attrs) do
    changeset = changeset(attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:external_id]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
