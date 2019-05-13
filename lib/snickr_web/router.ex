defmodule SnickrWeb.Router do
  use SnickrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SnickrWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SnickrWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create, :show]
    post "/users/search", UserController, :search
    post "/users/invite", UserController, :inviteSearch
    post "/invites/:id", InviteController, :show
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/workspaces", WorkspaceController, only: [:index, :new, :create, :show]
    resources "/channels", ChannelController, only: [:new, :create, :show]
    resources "/invites", InviteController, only: [:index, :show, :create]
    post "/invites/:id/accept", InviteController, :accept
    post "/subscriptions", SubscriptionController, :create
    delete "/subscriptions/:user_id/:channel_id", SubscriptionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", SnickrWeb do
  #   pipe_through :api
  # end
end
