# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
MediaServer.Accounts.register_user(%{
  email: System.get_env("SETUP_ADMIN_EMAIL"),
  name: System.get_env("SETUP_ADMIN_NAME"),
  password: System.get_env("SETUP_ADMIN_PASSWORD"),
  is_admin: true
})

MediaServerWeb.Repositories.Movies.get_all()
|> Enum.map(fn item ->
  %{
    radarr_id: item["id"],
    tmdb_id: item["tmdbId"],
    title: item["title"],
    overview: item["overview"],
    poster: MediaServer.Helpers.get_poster(item),
    background: MediaServer.Helpers.get_background(item),
  }
end)
|> Enum.chunk_every(100)
|> Enum.each(fn chunk ->
  MediaServer.AddMovies.new(%{"items" => chunk})
  |> Oban.insert()
end)

MediaServer.AddSeries.new(%{"items" => MediaServerWeb.Repositories.Series.get_all()
  |> Enum.map(fn item -> %{
    sonarr_id: item["id"],
    tmdb_id: item["tmdbId"],
    seasons: item["statistics"]["seasonCount"],
    title: item["title"],
    overview: item["overview"],
    poster: MediaServer.Helpers.get_poster(item),
    background: MediaServer.Helpers.get_background(item),
  } end)
})
|> Oban.insert()

#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
