defmodule MediaServer.Subtitles.Movie do
  alias MediaServer.Indexers.Movie
  alias MediaServer.Subtitles

  def get_subtitle_path_for(id) do
    movie = Movie.get_movie(id)

    Subtitles.get_subtitle(movie["folderName"], movie["movieFile"]["relativePath"])
    |> Subtitles.handle_subtitle(movie["folderName"])
  end
end
