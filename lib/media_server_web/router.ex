defmodule MediaServerWeb.Router do
  use MediaServerWeb, :router

  import MediaServerWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MediaServerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", HomeLive.Index, :index

    live "/movies", MoviesLive.Index, :index
    live "/movies/:movie", MoviesLive.Show, :show
    get "/movies/:movie/stream", StreamController, :show

    live "/series", SeriesLive.Index, :index
    live "/series/:serie", SeriesLive.Show, :show

    get "/episodes/:episode/stream", StreamController, :show

    live_session :watch, root_layout: {MediaServerWeb.WatchView, "watch.html"} do
      live "/movies/:movie/watch", WatchMovieLive.Show, :show
      live "/episodes/:episode/watch", WatchEpisodeLive.Show, :show
    end

    live "/continues", WatchesLive.Index, :index

    live "/settings", SettingsLive.Index, :index

    delete "/logout", UserSessionController, :delete
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MediaServerWeb.Telemetry

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
