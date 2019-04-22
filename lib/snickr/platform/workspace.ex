defmodule Snickr.Platform.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Platform.Channel
  alias Snickr.Accounts.User

  schema "workspaces" do
    field :description, :string
    field :name, :string, null: false
    has_one :created_by_user, User
    has_many :channels, Channel

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
