defmodule MediaServer.Repo.Migrations.RenameMovieWatchesTableToMovieContinuesTable do
  use Ecto.Migration

  def change do
    rename table("movie_watches"), to: table("movie_continues")
  end
end
