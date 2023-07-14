defmodule MediaServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MediaServer.Repo,
      # Start the Telemetry supervisor
      MediaServerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MediaServer.PubSub},
      # Start the Endpoint (http/https)
      MediaServerWeb.Endpoint,
      # Start a worker by calling: MediaServer.Worker.start_link(arg)
      # {MediaServer.Worker, arg}
      MediaServerWeb.Presence,

      MediaServer.UserCreated,

      MediaServer.Token,
      MediaServer.MoviesIndex,
      MediaServer.MoviesWebhook,
      MediaServer.SeriesIndex,
      MediaServer.SeriesWebhook
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MediaServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MediaServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
