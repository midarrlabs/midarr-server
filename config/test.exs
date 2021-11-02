import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :media_server, MediaServer.Repo,
  username: "my_user",
  password: "password123",
  database: "my_database",
  hostname: "postgresql-test",
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :media_server, MediaServerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "62B5xZrG1FF9/9KoKGBTwSiiuq4aGoO/m2ZBORy8I1D/k4DXyi/khr1NBKmoFl0p",
  server: false

# In test we don't send emails.
config :media_server, MediaServer.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
