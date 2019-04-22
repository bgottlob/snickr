defmodule SnickrWeb.PageController do
  use SnickrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
