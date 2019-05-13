defmodule Snickr.Accounts.AdminInvitation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Accounts.User
  alias Snickr.Platform.Workspace

  schema "admininvitations" do
    field :status, :string

    belongs_to :user, User
    belongs_to :workspace, Workspace
    belongs_to :invited_by_user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(admin_invitation, attrs) do
    admin_invitation
    |> cast(attrs, [:status, :user_id, :workspace_id, :invited_by_user_id])
    |> validate_required([:status, :user_id, :workspace_id, :invited_by_user_id])
    |> validate_inclusion(:status, ["pending", "accepted"])
    |> assoc_constraint(:user)
    |> assoc_constraint(:workspace)
    |> assoc_constraint(:invited_by_user)
  end
end
