# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :media_server,
  ecto_repos: [MediaServer.Repo]

# Configures the endpoint
config :media_server, MediaServerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MediaServerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MediaServer.PubSub,
  live_view: [signing_salt: "Kmu9TNrl"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :media_server, MediaServer.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.1.8",
  default: [
    args: ~w(
          --config=tailwind.config.js
          --input=css/app.css
          --output=../priv/static/assets/app.css
        ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :media_server, MediaServer.Repo,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_DATABASE"),
  hostname: System.get_env("DB_HOSTNAME")

config :web_push_elixir,
  vapid_public_key: System.get_env("VAPID_PUBLIC_KEY"),
  vapid_private_key: System.get_env("VAPID_PRIVATE_KEY"),
  vapid_subject: System.get_env("VAPID_SUBJECT")

config :oapi_tmdb,
  api_key: System.get_env("TMDB_API_KEY")

config :media_server, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 10],
  repo: MediaServer.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
