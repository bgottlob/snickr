defmodule SnickrWeb.WorkspaceView do
  use SnickrWeb, :view

  import SnickrWeb.ChannelView, only: [direct_recipient: 2]

  def sort_channels(c1, c2) do
    precedence = ["public", "private", "direct"]
    Enum.find_index(precedence, fn x -> x == c1.type end) <=
      Enum.find_index(precedence, fn x -> x == c2.type end)
  end
end
