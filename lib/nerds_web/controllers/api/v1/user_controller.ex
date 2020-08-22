defmodule NerdsWeb.API.V1.UserController do
  use NerdsWeb, :controller

  action_fallback NerdsWeb.FallbackController

  def index(conn, _params) do
    users = [ExOauth2Provider.Plug.current_resource_owner(conn)]
    render(conn, "index.json", users: users)
  end
end
