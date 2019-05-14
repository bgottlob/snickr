defmodule SnickrWeb.ChannelController do
  use SnickrWeb, :controller

  alias Snickr.Accounts
  alias Snickr.Platform
  alias Snickr.Platform.{Channel, Message}

  plug :authenticate_user

  def new(conn, %{"workspace_id" => workspace_id}) do
    # TODO make sure users can only access this page if they are members of the
    # workspace
    render(conn, "new.html",
      workspace_id: workspace_id,
      changeset:
      Channel.changeset(%Channel{}, %{created_by_user_id: conn.assigns.current_user.id, workspace_id: workspace_id})
    )
  end

  def create(conn, %{"channel" => %{"type" => "direct"} = attrs}) do
    attrs = Map.put(attrs, "from_user_id", conn.assigns.current_user.id)
    to_user = Accounts.get_user(Map.fetch!(attrs, "to_user_id"))
    case Platform.create_channel(attrs) do
      {:ok, %{:channel => channel}} ->
        conn
        |> put_flash(:info, "Welcome to your first message with #{to_user.first_name}!")
        |> redirect(to: Routes.channel_path(conn, :show, channel.id))
      {:error, :direct_channel_already_exists, channel_id} ->
        conn
        |> redirect(to: Routes.channel_path(conn, :show, channel_id))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "An error occurred")
        |> redirect(to: Routes.workspace_path(conn, :show, Map.fetch(attrs, "workspace_id")))
    end
  end

  def create(conn, %{"channel" => attrs}) do
    attrs = Map.put(attrs, "created_by_user_id", conn.assigns.current_user.id)
    case Platform.create_channel(attrs) do
      {:ok, %{:channel => channel}} ->
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
