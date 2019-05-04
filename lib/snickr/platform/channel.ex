defmodule Snickr.Platform.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Platform.Workspace
  alias Snickr.Accounts.User

  schema "channels" do
    field :description, :string
    field :name, :string
    field :type, :string

    belongs_to :created_by_user, User
    belongs_to :workspace, Workspace

    many_to_many :subscribers, User, join_through: "subscriptions"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :description, :type])
    |> validate_required([:name, :description, :type])
    |> validate_inclusion(:type, ["public", "private", "direct"])
  end

  def create_changeset(channel, created_by_user_id, workspace_id, attrs) do
    channel
    |> __MODULE__.changeset(attrs)
    |> put_change(:created_by_user_id, created_by_user_id)
    |> put_change(:workspace_id, workspace_id)
    |> validate_required([:created_by_user_id, :workspace_id])
  end
end
