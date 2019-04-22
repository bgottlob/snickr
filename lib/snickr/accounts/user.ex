defmodule Snickr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Platform.Workspace
  alias Snickr.Platform.Channel

  schema "users" do
    field :email, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :password_hash, :string, null: false
    field :salt, :string, null: false
    field :username, :string, null: false

    has_many :created_workspaces, Workspace
    has_many :created_channels, Channel

    many_to_many :member_of_workspaces, Workspace, join_through: "memberships"
    many_to_many :admin_of_workspaces, Workspace, join_through: "admins"
    many_to_many :subscribed_to_channels, Channel, join_through: "subscriptions"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :email, :password_hash, :salt])
    |> validate_required([:username, :first_name, :last_name, :email, :password_hash, :salt])
  end
end
