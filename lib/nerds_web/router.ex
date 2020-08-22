defmodule NerdsWeb.Router do
  use NerdsWeb, :router
  use Pow.Phoenix.Router
  use PhoenixOauth2Provider.Router, otp_app: :nerds

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api_protected do
    plug ExOauth2Provider.Plug.VerifyHeader, otp_app: :nerds, realm: "Bearer"
    plug ExOauth2Provider.Plug.EnsureAuthenticated
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/" do
    pipe_through :api

    oauth_api_routes()
  end

  scope "/" do
    pipe_through [:browser, :protected]

    oauth_routes()
  end

  scope "/", NerdsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", NerdsWeb.API.V1 do
    pipe_through [:api, :api_protected]

    resources "/accounts", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", NerdsWeb do
  #   pipe_through :api
  # end
end
