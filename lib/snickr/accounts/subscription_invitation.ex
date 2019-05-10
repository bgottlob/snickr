defmodule Snickr.Accounts.SubscriptionInvitation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Accounts.User
  alias Snickr.Platform.Channel

  schema "subscriptioninvitations" do
    field :status, :string

    belongs_to :user, User
    belongs_to :channel, Channel
    belongs_to :invited_by_user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subscription_invitation, attrs) do
    subscription_invitation
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
