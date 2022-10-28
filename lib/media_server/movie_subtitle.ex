defmodule MediaServer.Movies.Subtitle do
  alias MediaServer.Movies.Indexer
  alias MediaServer.Subtitles

  def get_subtitle_path_for(id) do
    movie = Indexer.get_movie(id)

    Subtitles.get_subtitle(movie["folderName"], movie["movieFile"]["relativePath"])
    |> Subtitles.handle_subtitle(movie["folderName"])
  end
end
