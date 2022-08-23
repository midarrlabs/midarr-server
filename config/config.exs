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
      ~w(js/app.js js/player.js js/cast.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :media_server, MediaServer.Repo,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_DATABASE"),
  hostname: System.get_env("DB_HOSTNAME")

config :media_server,
  app_name: "Midarr",
  app_url: System.get_env("APP_URL"),
  app_mailer_from: System.get_env("APP_MAILER_FROM") || "example@email.com",
  movies_base_url: System.get_env("RADARR_BASE_URL"),
  movies_api_key: System.get_env("RADARR_API_KEY"),
  series_base_url: System.get_env("SONARR_BASE_URL"),
  series_api_key: System.get_env("SONARR_API_KEY")

config :tailwind,
  version: "3.0.23",
  default: [
    args: ~w(
          --config=tailwind.config.js
          --input=css/app.css
          --output=../priv/static/assets/app.css
        ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
