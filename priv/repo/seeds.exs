alias MediaServer.Repo
alias MediaServer.Media.Type

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
Repo.insert(Type.changeset(%Type{}, %{name: "Movie"}))
Repo.insert(Type.changeset(%Type{}, %{name: "Show"}))
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
