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
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", HomeLive.Index, :index

    live "/movies", MoviesLive.Index, :index
    live "/movies/:id", MoviesLive.Show, :show

    live "/series", SeriesLive.Index, :index
    live "/series/:id", SeriesLive.Show, :show

    live_session :watch, root_layout: {MediaServerWeb.WatchView, :watch} do
      live "/watch", WatchLive.Index, :index
    end

    live_session :plain, root_layout: {MediaServerWeb.PlainView, :plain} do
      live "/playlists", PlaylistLive.Index, :index
      live "/playlists/:id", PlaylistLive.Show, :show

      live "/history", HistoryLive.Index, :index

      live "/search", SearchLive.Index, :index

      live "/settings", SettingsLive.Index, :index
    end

    get "/images", ImagesController, :index

    delete "/logout", UserSessionController, :delete
  end

  scope "/api", MediaServerWeb do
    pipe_through :api

    get "/stream", StreamController, :index
    get "/subtitle", SubtitleController, :index

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
