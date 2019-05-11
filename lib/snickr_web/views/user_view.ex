defmodule SnickrWeb.UserView do
  use SnickrWeb, :view

  def render("search_result.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      full_name: "#{user.first_name} #{user.last_name}"
    }
  end
end
