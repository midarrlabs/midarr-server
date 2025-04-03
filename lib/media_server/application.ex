defmodule MediaServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MediaServerWeb.Telemetry,
      MediaServer.Repo,
      {DNSCluster, query: Application.get_env(:media_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MediaServer.PubSub},
      # Start a worker by calling: MediaServer.Worker.start_link(arg)
      # {MediaServer.Worker, arg},
      # Start to serve requests, typically the last entry
      MediaServerWeb.Endpoint
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
