defmodule Snickr.Accounts.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Snickr.Accounts.User
  alias Snickr.Platform.Channel

  @primary_key false
  schema "subscriptions" do
    belongs_to :user, User, primary_key: true
    belongs_to :channel_id, Channel, primary_key: true

    timestamps(updated_at: false, type: :utc_datetime)
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [])
    |> validate_required([])
  end
end
