defmodule SnickrWeb.MessageController do
  use SnickrWeb, :controller

  alias Snickr.Platform

  plug :authenticate_user

  def search(conn, %{"term" => term, "channel_id" => channel_id}) do
    messages =
      for m <- Platform.search_messages(term, channel_id) do
        %{
          content: m.content,
          inserted_at: m.inserted_at,
          sent_by_user: %{username: m.sent_by_user.username}
        }
      end

    json(conn, messages)
  end
end
