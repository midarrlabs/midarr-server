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

types = [
  %{label: "movie"},
  %{label: "series"},
  %{label: "episode"},
  %{label: "person"}
]

MediaServer.Repo.insert_all(MediaServer.Types, types, on_conflict: :nothing)

actions = [
  %{label: "played"},
  %{label: "followed"}
]

MediaServer.Repo.insert_all(MediaServer.Actions, actions, on_conflict: :nothing)

MediaServer.ItemInserter.new(%{"items" => MediaServer.MoviesIndex.for_db()})
|> Oban.insert()

MediaServer.AddSeries.new(%{"items" => MediaServer.SeriesIndex.for_db()})
|> Oban.insert()

#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
