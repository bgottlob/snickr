defmodule Snickr.Accounts.MembershipInvitation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Accounts.User
  alias Snickr.Platform.Workspace

  schema "membershipinvitations" do
    field :status, :string

    belongs_to :user, User
    belongs_to :workspace, Workspace
    belongs_to :invited_by_user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(membership_invitation, attrs) do
    membership_invitation
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
