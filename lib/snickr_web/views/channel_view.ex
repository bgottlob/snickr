defmodule SnickrWeb.ChannelView do
  use SnickrWeb, :view

  import Ecto.Query, only: [from: 2]

  alias Snickr.Repo
  alias Snickr.Accounts.User
  alias Snickr.Platform.Channel

  def direct_recipient(%Channel{} = channel, %User{} = current_user) do
    user = Repo.one(from u in User,
      join: c in assoc(u, :subscribed_to_channels),
      where: c.id == ^channel.id and u.id != ^current_user.id)
    "#{user.first_name} #{user.last_name}"
  end
end
