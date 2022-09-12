defmodule MediaServer.Repo do
  use Ecto.Repo,
    otp_app: :media_server,
    adapter: Ecto.Adapters.SQLite3
end
