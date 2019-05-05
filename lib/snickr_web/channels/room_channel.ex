defmodule SnickrWeb.RoomChannel do
  use Phoenix.Channel

  alias Snickr.Repo
  alias Snickr.Platform

  def join("room:" <> channel_id, _message, socket) do
    messages =
      for m <- Enum.reverse(Platform.list_messages_in_channel(channel_id)) do
        %{
          content: m.content,
          inserted_at: m.inserted_at,
          sent_by_user: %{username: m.sent_by_user.username}
        }
      end

    {:ok, %{messages: messages}, assign(socket, :channel_id, String.to_integer(channel_id))}
  end

  def handle_in(
        "new_msg",
        %{"content" => content, "channel_id" => channel_id, "user_id" => user_id},
        socket
      ) do
    case Platform.create_message(user_id, channel_id, %{content: content}) do
      {:ok, message} ->
        message = Repo.preload(message, :sent_by_user)

        broadcast!(socket, "new_msg", %{
          inserted_at: DateTime.to_string(message.inserted_at),
          content: content,
          sent_by_user: %{username: message.sent_by_user.username}
        })

        {:reply, :ok, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
