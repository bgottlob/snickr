defmodule SnickrWeb.MessageController do
  use SnickrWeb, :controller

  alias Snickr.Platform

  plug :authenticate_user when action in [:create]

  def create(conn, %{"message" => message_attrs, "channel_id" => channel_id}) do
    case Platform.create_message(conn.assigns.current_user.id, channel_id, message_attrs) do
      {:ok, message} ->
    end
  end
end
