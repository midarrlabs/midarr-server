MediaServer.MoviesFixtures.setup()
MediaServer.SeriesFixtures.setup()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MediaServer.Repo, :manual)
