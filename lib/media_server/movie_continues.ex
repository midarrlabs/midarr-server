defmodule MediaServer.MovieContinues do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "movie_continues" do
    belongs_to :movie, MediaServer.Movies, foreign_key: :movies_id
    belongs_to :user, MediaServer.Accounts.User

    field :current_time, :integer
    field :duration, :integer

    timestamps()
  end

  def changeset(continue, attrs) do
    continue
    |> cast(attrs, [:movies_id, :current_time, :duration, :user_id])
    |> validate_required([:movies_id, :current_time, :duration, :user_id])
  end

  def insert_or_update(attrs) do
    case Repo.get_by(__MODULE__, movies_id: attrs.movies_id, user_id: attrs.user_id) do
      nil ->
        %__MODULE__{
          movies_id: attrs.movies_id,
          user_id: attrs.user_id
        }

      item ->
        item
    end
    |> changeset(
      Enum.into(attrs, %{
        updated_at: DateTime.utc_now()
      })
    )
    |> Repo.insert_or_update()
  end

  def where(attrs) do
    Repo.get_by(__MODULE__, attrs)
  end
end
