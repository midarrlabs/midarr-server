defmodule MediaServer.Workers.AddMovieGenres do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"id" => id}}) do

    movie = MediaServer.Repo.get_by(MediaServer.Movies, id: id)

    [genres | _] = MediaServer.MoviesIndex.search(movie.title)

    Enum.each(genres["genres"], fn genre ->
      case MediaServer.Repo.get_by(MediaServer.Genres, name: genre) do
        %MediaServer.Genres{id: genre_id} ->
          MediaServer.MovieGenres.insert(%{
            movies_id: movie.id,
            genres_id: genre_id
          })

        _ ->
          :noop
      end
    end)

    :ok
  end
end
