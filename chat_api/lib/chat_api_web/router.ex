defmodule ChatApiWeb.Router do
  use ChatApiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(ChatApi.Auth.AuthAccessPipeline)
  end

  pipeline :auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/", ChatApiWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", ChatApiWeb do
    post("/users", UserController, :create)
  end

  scope "/api", ChatApiWeb do
    pipe_through(:api)
    post("/sessions", SessionController, :create)
    delete("/sessions", SessionController, :delete)
    post("/sessions/refresh", SessionController, :refresh)

    # resources("/users", UserController, only: [:create])
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatApiWeb do
  #   pipe_through :api
  # end
end
