defmodule SnickrWeb.WorkspaceController do
  use SnickrWeb, :controller

  alias Snickr.Accounts
  alias Snickr.Platform
  alias Snickr.Platform.{Channel, Workspace}

  alias Snickr.Accounts
  # alias Snickr.Accounts.create_membership_invitation
  
  plug :authenticate_user when action in [:new, :index, :show]

  def new(conn, _attrs) do
    render(conn, "new.html", changeset: Workspace.changeset(%Workspace{}, %{}))
  end

  def create(conn, %{"workspace" => workspace_attrs}) do
    case Platform.create_workspace(conn.assigns.current_user, workspace_attrs) do
      {:ok, workspace} ->
        conn
        |> put_flash(:info, "You have successfully created the #{workspace.name} workspace!")
        |> redirect(to: Routes.workspace_path(conn, :show, workspace.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _attrs) do
    render(conn, "index.html", workspaces: Platform.list_workspaces(conn.assigns.current_user))
  end

  def show(conn, %{"id" => id}) do
    case Platform.get_workspace_with_member(conn.assigns.current_user, id) do
      nil ->
        conn
        |> put_flash(:error, "Workspace not found")
        |> redirect(to: Routes.workspace_path(conn, :index))

      workspace ->
        render(conn, "show.html", workspace: workspace,
          channels: Accounts.list_subscribed_to_channels(conn.assigns.current_user),
          public_channels: Platform.list_public_channels(workspace)
        )
    end
  end
end
