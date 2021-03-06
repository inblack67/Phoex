defmodule PhoexWeb.Router do
  use PhoexWeb, :router
  alias PhoexWeb.Plugs.SetUser

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(SetUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PhoexWeb do
    pipe_through(:browser)

    get("/", RoomController, :index)
    resources("/rooms", RoomController, except: [:index])
    resources("/sessions", SessionController, only: [:new, :create])
    resources("/registration", RegistrationController, only: [:new, :create])
    delete("/sign_out", SessionController, :delete)

    # without resources
    # get("/create-room", RoomController, :new)
    # post("/rooms", RoomController, :create)
    # get("/rooms/:id", RoomController, :show)
    # get("/rooms/:id/edit", RoomController, :edit)
    # put("/rooms/:id", RoomController, :update)
    # delete("/rooms/:id", RoomController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoexWeb do
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
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: PhoexWeb.Telemetry)
    end
  end
end
