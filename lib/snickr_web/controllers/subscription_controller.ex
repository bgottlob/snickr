defmodule SnickrWeb.SubscriptionController do
  use SnickrWeb, :controller

  alias Snickr.Repo
  alias Snickr.Accounts
  alias Snickr.Accounts.Subscription
  alias Snickr.Platform.{Channel, Workspace}

  plug :authenticate_user

  defp error_on_create(conn) do
    conn
    |> put_flash(:error, "An error occurred")
    |> redirect(to: Routes.workspace_path(conn, :index))
  end

  def create(conn, %{"subscription" => %{"channel_id" => channel_id} = attrs}) do
    channel = Repo.get(Channel, channel_id)
    attrs = Map.put(attrs, "user_id", conn.assigns.current_user.id)
    case channel.type == "public" &&
      Accounts.member?(conn.assigns.current_user, Repo.get(Workspace, channel.workspace_id)) do
      true ->
        case Accounts.create_subscription(attrs) do
          {:ok, subscription} ->
            subscription = Repo.preload(subscription, :channel)
            conn
            |> put_flash(:info, "Welcome to #{subscription.channel.name}")
            |> redirect(to: Routes.channel_path(conn, :show, subscription.channel.id))
          {:error, _reason} ->
            error_on_create(conn)
        end
      false ->
        error_on_create(conn)
    end
  end

  def delete(conn, %{"user_id" => user_id, "channel_id" => channel_id}) do
    subscription = Repo.get_by(Subscription, user_id: user_id, channel_id: channel_id)
    case Accounts.delete_subscription(subscription) do
      {:ok, _subscription} ->
        channel = Repo.get(Channel, channel_id)
        conn
        |> put_flash(:info, "You successfully unsubscribed from #{channel.name}")
        |> redirect(to: Routes.workspace_path(conn, :show, channel.workspace_id))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "An error occurred")
        |> redirect(to: Routes.channel_path(conn, :show, channel_id))
    end
  end
end
