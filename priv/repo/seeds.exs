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

genres = [
  %{tmdb_id: 28, name: "Action"},
  %{tmdb_id: 12, name: "Adventure"},
  %{tmdb_id: 16, name: "Animation"},
  %{tmdb_id: 35, name: "Comedy"},
  %{tmdb_id: 80, name: "Crime"},
  %{tmdb_id: 99, name: "Documentary"},
  %{tmdb_id: 18, name: "Drama"},
  %{tmdb_id: 10751, name: "Family"},
  %{tmdb_id: 14, name: "Fantasy"},
  %{tmdb_id: 36, name: "History"},
  %{tmdb_id: 27, name: "Horror"},
  %{tmdb_id: 10402, name: "Music"},
  %{tmdb_id: 9648, name: "Mystery"},
  %{tmdb_id: 10749, name: "Romance"},
  %{tmdb_id: 878, name: "Science Fiction"},
  %{tmdb_id: 10770, name: "TV Movie"},
  %{tmdb_id: 53, name: "Thriller"},
  %{tmdb_id: 10752, name: "War"},
  %{tmdb_id: 37, name: "Western"},
  %{tmdb_id: 10759, name: "Action & Adventure"},
  %{tmdb_id: 10762, name: "Kids"},
  %{tmdb_id: 10763, name: "News"},
  %{tmdb_id: 10764, name: "Reality"},
  %{tmdb_id: 10765, name: "Sci-Fi & Fantasy"},
  %{tmdb_id: 10766, name: "Soap"},
  %{tmdb_id: 10767, name: "Talk"},
  %{tmdb_id: 10768, name: "War & Politics"}
]

Enum.each(genres, &MediaServer.Genres.insert/1)

MediaServer.Workers.AddMovies.new(%{}) |> Oban.insert()

MediaServer.Workers.AddSeries.new(%{}) |> Oban.insert()

#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
