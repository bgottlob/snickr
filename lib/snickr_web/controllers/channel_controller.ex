defmodule SnickrWeb.ChannelController do
  use SnickrWeb, :controller

  alias Snickr.Platform
  alias Snickr.Platform.{Channel, Message}

  plug :authenticate_user when action in [:new, :index, :show]

  def new(conn, %{"workspace_id" => workspace_id}) do
    # TODO make sure users can only access this page if they are members of the
    # workspace
    render(conn, "new.html",
      workspace_id: workspace_id,
      changeset:
        Channel.create_changeset(%Channel{}, conn.assigns.current_user.id, workspace_id, %{})
    )
  end

  def create(conn, %{"channel" => channel_attrs, "workspace_id" => workspace_id}) do
    {workspace_id, _} = Integer.parse(workspace_id)

    case Platform.create_channel(conn.assigns.current_user.id, workspace_id, channel_attrs) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "You have successfully created the #{channel.name} channel")
        |> redirect(to: Routes.channel_path(conn, :show, channel.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _attrs) do
    render(conn, "index.html", workspaces: Platform.list_workspaces(conn.assigns.current_user))
  end

  def show(conn, %{"id" => id}) do
    case Platform.get_channel_with_subscriber(conn.assigns.current_user, id) do
      nil ->
        conn
        |> put_flash(:error, "Channel not found")
        |> redirect(to: Routes.workspace_path(conn, :index))

      channel ->
        render(conn, "show.html", channel: channel)
    end
  end
end
