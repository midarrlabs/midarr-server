defmodule MediaServer.Seasons do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :number, :poster]
  }

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:number]
  }

  schema "seasons" do
    field :number, :integer
    field :poster, :string

    belongs_to :series, MediaServer.Series, foreign_key: :series_id

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:series_id, :number, :poster])
    |> validate_required([:series_id, :number])
  end

  def insert(attrs) do
    changeset = changeset(attrs)

    case MediaServer.Repo.insert(changeset, on_conflict: :nothing, conflict_target: [:series_id, :number]) do
      {:ok, record} ->
        {:ok, record}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
