defmodule Snickr.Platform.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Platform.Channel
  alias Snickr.Accounts.{AdminInvitation, MembershipInvitation, User}

  schema "workspaces" do
    field :description, :string, null: false
    field :name, :string, null: false
    belongs_to :created_by_user, User
    has_many :channels, Channel

    many_to_many :members, User, join_through: "memberships"
    many_to_many :admins, User, join_through: "admins"

    has_many :membership_invitations, MembershipInvitation, foreign_key: :workspace_id
    has_many :admin_invitations, AdminInvitation, foreign_key: :workspace_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end

  def create_changeset(workspace, %User{} = created_by_user, attrs) do
    workspace
    |> changeset(attrs)
    |> put_assoc(:created_by_user, created_by_user)
    |> validate_required([:created_by_user])
  end
end
