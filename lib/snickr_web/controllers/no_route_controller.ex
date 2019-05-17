defmodule SnickrWeb.NoRouteController do
  use SnickrWeb, :controller

  def index(conn, _attrs) do
    conn
    |> put_status(:not_found)
    |> put_view(SnickrWeb.ErrorView)
    |> render("404.html")
  end
end
