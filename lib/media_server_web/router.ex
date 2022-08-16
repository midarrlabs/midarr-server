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

  pipeline :api do
    plug :accepts, ["json"]
    plug MediaServerWeb.Plugs.VerifyToken
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", HomeLive.Index, :index

    live "/movies", MoviesLive.Index, :index
    live "/movies/:id", MoviesLive.Show, :show

    live "/series", SeriesLive.Index, :index
    live "/series/:id", SeriesLive.Show, :show
    live "/series/:id/seasons/:number", SeasonsLive.Show, :show

    live_session :watch, root_layout: {MediaServerWeb.WatchView, "watch.html"} do
      live "/movies/:id/:action", WatchMovieLive.Show, :show
      live "/episodes/:id/watch", WatchEpisodeLive.Show, :show
    end

    live "/search", SearchLive.Index, :index

    live "/continues", ContinuesLive.Index, :index
    live "/favourites", FavouritesLive.Index, :index

    live "/settings", SettingsLive.Index, :index

    delete "/logout", UserSessionController, :delete
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
  end

  scope "/api", MediaServerWeb do
    pipe_through :api

    get "/movies/:id/stream", StreamMovieController, :show
    get "/movies/:id/subtitle", SubtitleMovieController, :show

    get "/episodes/:id/stream", StreamEpisodeController, :show
    get "/episodes/:id/subtitle", SubtitleEpisodeController, :show
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MediaServerWeb.Telemetry

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
