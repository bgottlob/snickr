defmodule Snickr.Accounts.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Snickr.Accounts.User
  alias Snickr.Platform.Channel

  @primary_key false
  schema "subscriptions" do
    belongs_to :user, User, primary_key: true
    belongs_to :channel, Channel, primary_key: true

    timestamps(updated_at: false, type: :utc_datetime)
  end

  @doc false
  def create_changeset(subscription, user_id, channel_id) do
    subscription
    |> change(%{})
    |> put_change(:user_id, user_id)
    |> put_change(:channel_id, channel_id)
    |> validate_required([:user_id, :channel_id])
  end
end
