defmodule MediaServer.MoviesSubtitle do
  def get_subtitle_path_for(id) do
    movie = MediaServer.MoviesIndex.find(id)

    MediaServer.Subtitles.get_subtitle(movie.folder_name, movie.relative_path)
    |> MediaServer.Subtitles.handle_subtitle(movie.folder_name)
  end
end
