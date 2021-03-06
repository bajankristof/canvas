defmodule CanvasWeb.Router do
  use CanvasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CanvasWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CanvasWeb do
    pipe_through :browser

    live "/", DocumentLive.Index, :index
    live "/:id", DocumentLive.Show, :show
  end

  scope "/api", CanvasWeb do
    pipe_through :api
    resources "/documents", DocumentController, except: [:update]
    get "/graphics/:document_id", GraphicsController, :show
    post "/graphics/:document_id/draw-rect", GraphicsController, :draw_rect
    post "/graphics/:document_id/flood-fill", GraphicsController, :flood_fill
  end

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
      live_dashboard "/dashboard", metrics: CanvasWeb.Telemetry
    end
  end
end
