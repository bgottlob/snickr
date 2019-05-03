defmodule Snickr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Platform.Workspace
  alias Snickr.Platform.Channel

  schema "users" do
    field :email, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    # virtual, won't be stored in db
    field :password, :string, virtual: true
    field :password_hash, :string, null: false
    field :username, :string, null: false

    has_many :created_workspaces, Workspace, foreign_key: :created_by_user_id
    has_many :created_channels, Channel, foreign_key: :created_by_user_id

    many_to_many :member_of_workspaces, Workspace, join_through: "memberships"
    many_to_many :admin_of_workspaces, Workspace, join_through: "admins"
    many_to_many :subscribed_to_channels, Channel, join_through: "subscriptions"

    timestamps(type: :utc_datetime)
  end

  @doc """
  Prepares a changeset for creating a new user.
  """
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :email, :password])
    |> validate_required([:username, :first_name, :last_name, :email, :password])
    |> validate_length(:password, min: 10, max: 100)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_password_hash()
    # Clear the plaintext password so it doesn't sit in memory
    |> delete_change(:password)
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
