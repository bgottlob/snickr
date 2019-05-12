defmodule SnickrWeb.UserController do
  use SnickrWeb, :controller

  alias Snickr.Accounts
  alias Snickr.Accounts.User

  plug :authenticate_user when action in [:show, :search]

  def new(conn, _attrs) do
    render(conn, "new.html", changeset: Accounts.change_user(%User{}, %{}))
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "You have successfully created a user account #{user.username}")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", user: Accounts.get_user!(id))
  end

  def search(conn, %{"term" => term, "workspace_id" => workspace_id}) when is_integer(workspace_id) do
    # TODO remove the current user from the result
    results =
      Accounts.list_users(term, workspace_id)
      |> Phoenix.View.render_many(SnickrWeb.UserView, "search_result.json")

    json(conn, results)
  end

  def inviteSearch(conn, %{"term" => term}) do
    # TODO remove the current user from the result
    results =
      Accounts.list_users(term)
      |> Phoenix.View.render_many(SnickrWeb.UserView, "search_result.json")

    json(conn, results)
  end
end
