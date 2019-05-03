defmodule SnickrWeb.SessionController do
  use SnickrWeb, :controller

  alias SnickrWeb.Router.Helpers, as: Routes

  def new(conn, _attrs) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case SnickrWeb.Auth.login_with_username_and_password(conn, username, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You have successfully logged in")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, :unauthorized, conn} ->
        conn
        |> put_flash(:error, "You failed to log in")
        |> render("new.html")
    end
  end

  def delete(conn, _attrs) do
    conn
    |> SnickrWeb.Auth.logout()
    |> put_flash(:info, "You have successfully logged out")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
