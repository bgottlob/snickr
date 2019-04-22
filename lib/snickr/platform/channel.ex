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
  end
end
