defmodule MediaServer.Media do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "media" do
    field :media_id, :integer

    belongs_to :media_type, MediaServer.MediaTypes

    timestamps()
  end

  def changeset(media, attrs) do
    media
    |> cast(attrs, [:media_id, :media_type_id])
    |> validate_required([:media_id, :media_type_id])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def all do
    Repo.all(__MODULE__)
  end

  def find_or_create(attrs) do
    media = Repo.get_by(__MODULE__, media_id: attrs.media_id)

    case media do
      nil ->
        {:ok, %__MODULE__{} = created} = create(attrs)

        created

      _ ->
        media
    end
  end
end
