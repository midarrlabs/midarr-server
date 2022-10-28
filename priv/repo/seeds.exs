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

MediaServer.MediaTypes.create(%{
  type: "movie"
})

MediaServer.MediaTypes.create(%{
  type: "episode"
})

MediaServer.Actions.create(%{
  action: "played"
})

#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
