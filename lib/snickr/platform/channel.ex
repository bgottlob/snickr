defmodule Snickr.Platform.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Platform.Workspace
  alias Snickr.Accounts.User

  schema "channels" do
    field :description, :string
    field :name, :string
    field :type, :string
    has_one :created_by_user_id, User
    belongs_to :workspace, Workspace

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :description, :type])
    |> validate_required([:name, :description, :type])
  end
end
