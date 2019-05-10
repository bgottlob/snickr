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
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
