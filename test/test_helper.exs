MediaServer.MoviesFixtures.setup()
MediaServer.SeriesFixtures.setup()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MediaServer.Repo, :manual)
Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, Application.get_env(:media_server, :app_url))