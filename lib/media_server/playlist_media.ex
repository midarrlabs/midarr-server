defmodule MediaServer.Movies.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  alias MediaServer.Repo

  schema "playlist_media" do

    belongs_to :playlist, MediaServer.Playlists.Playlist
    belongs_to :media, MediaServer.Media
  end

  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:playlist_id, :media_id])
    |> validate_required([:playlist_id, :media_id])
  end

  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def all do
    Repo.all(__MODULE__)
  end

  def find(id) do
    Repo.get!(__MODULE__, id)
  end

  def delete(id) do
    find(id)
    |> Repo.delete()
  end

  def insert_or_delete(ids, attrs \\ %{}) do
    ids
    |> Enum.each(fn item ->
      {id, result} = item

      case result do
        "true" ->
          media = Repo.get_by(__MODULE__, playlist_id: id, media_id: attrs.media_id)

          case media do
            nil ->
              attrs
              |> Enum.into(%{
                playlist_id: id
              })
              |> create()

            _ ->
              nil
          end

        "false" ->
          media = Repo.get_by(__MODULE__, playlist_id: id, media_id: attrs.media_id)

          case media do
            nil -> nil
            _ -> delete(media.id)
          end
      end
    end)
  end
end
