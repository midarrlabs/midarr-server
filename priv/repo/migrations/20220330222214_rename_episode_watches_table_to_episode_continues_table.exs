defmodule MediaServer.Repo.Migrations.RenameEpisodeWatchesTableToEpisodeContinuesTable do
  use Ecto.Migration

  def change do
    rename table("episode_watches"), to: table("episode_continues")
  end
end
