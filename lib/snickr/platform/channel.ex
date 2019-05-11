defmodule Snickr.Platform.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Platform.Workspace
  alias Snickr.Accounts.{SubscriptionInvitation, User}

  schema "channels" do
    field :description, :string
    field :name, :string
    field :type, :string

    belongs_to :created_by_user, User
    belongs_to :workspace, Workspace

    has_many :invitations, SubscriptionInvitation, foreign_key: :channel_id

    many_to_many :subscribers, User, join_through: "subscriptions"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:description, :name, :type, :created_by_user_id, :workspace_id])
    |> validate_required([:name, :description, :type, :created_by_user_id, :workspace_id])
    |> validate_inclusion(:type, ["public", "private", "direct"])
    |> assoc_constraint(:created_by_user)
    |> assoc_constraint(:workspace)
  end
end
