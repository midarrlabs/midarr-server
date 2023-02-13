defmodule MediaServer.MoviesSubtitle do
  def get_subtitle_path_for(id) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    MediaServer.Subtitles.get_subtitle("#{ MediaServer.MoviesIndex.get_root_path() }/#{ MediaServer.MoviesIndex.get_folder_path(movie) }", MediaServer.MoviesIndex.get_file_path(movie))
    |> MediaServer.Subtitles.handle_subtitle("#{ MediaServer.MoviesIndex.get_root_path() }/#{ MediaServer.MoviesIndex.get_folder_path(movie) }")
  end
end
