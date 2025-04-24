defmodule MediaServerWeb.Router do
  use MediaServerWeb, :router

  import MediaServerWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MediaServerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug MediaServerWeb.VerifyToken
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create

    get "/auth", OAuthController, :index
    get "/auth/callback", OAuthController, :callback
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :default, on_mount: [MediaServerWeb.UserNavigation] do
      live "/", HomeLive.Index, :index

      live "/movies", MoviesLive.Index, :index
      live "/movies/:id", MoviesLive.Show, :show

      live "/series", SeriesLive.Index, :index
      live "/series/:id", SeriesLive.Show, :show

      live "/people", PeopleLive.Index, :index
      live "/people/:id", PeopleLive.Show, :show

      live "/history", HistoryLive.Index, :index

      live "/search", SearchLive.Index, :index

      live "/settings", SettingsLive.Index, :index
    end

    live_session :watch, on_mount: [MediaServerWeb.UserNavigation] do
      live "/watch", WatchLive.Index, :index
    end

    delete "/logout", UserSessionController, :delete
  end

  scope "/api", MediaServerWeb do
    pipe_through :api

    get "/movies", MoviesController, :index
    get "/movies/:id", MoviesController, :show

    get "/series", SeriesController, :index
    get "/series/:id", SeriesController, :show
    get "/series/:id/seasons", SeasonsController, :index

    get "/images", ImagesController, :index

    get "/stream", StreamController, :index

    get "/subtitle", SubtitleController, :index

    get "/search", SearchController, :index

    post "/webhooks/:id", WebhooksController, :create
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MediaServerWeb.Telemetry

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
