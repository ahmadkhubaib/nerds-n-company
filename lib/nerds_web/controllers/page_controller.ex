defmodule NerdsWeb.PageController do
  use NerdsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
