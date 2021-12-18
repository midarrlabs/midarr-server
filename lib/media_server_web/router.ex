defmodule MediaServerWeb.Router do
  use MediaServerWeb, :router

  import MediaServerWeb.UserAuth

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
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", HomeLive.Index, :index

    live "/libraries", LibraryLive.Index, :index
    live "/libraries/new", LibraryLive.Index, :new
    live "/libraries/:id/edit", LibraryLive.Index, :edit
    live "/libraries/:id", LibraryLive.Show, :show
    live "/libraries/:id/show/edit", LibraryLive.Show, :edit

    live "/files/:id", FileLive.Show, :show
    live "/files/:id/identify", IdentifyLive.Show, :show
    get "/files/:id/watch", StreamController, :show
    live_session :stream, root_layout: {MediaServerWeb.StreamView, "stream.html"} do
      live "/files/:id/stream", StreamLive.Show, :show
    end

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    delete "/logout", UserSessionController, :delete
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api

  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MediaServerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
