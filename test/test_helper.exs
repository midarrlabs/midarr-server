ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MediaServer.Repo, :manual)

DynamicSupervisor.start_child(MediaServer.DynamicSupervisor, {Plug.Cowboy, scheme: :http, plug: MediaServer.MockServer, options: [port: 8081]})
