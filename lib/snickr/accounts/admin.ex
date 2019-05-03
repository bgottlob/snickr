defmodule Snickr.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Accounts.User
  alias Snickr.Platform.Workspace

  @primary_key false
  schema "admins" do
    belongs_to :user, User, primary_key: true
    belongs_to :workspace, Workspace, primary_key: true

    timestamps(updated_at: false, type: :utc_datetime)
  end

  @doc false
  def create_changeset(admin, user, workspace) do
    admin
    |> cast(%{}, [])
    |> put_assoc(:user, user)
    |> put_assoc(:workspace, workspace)
    |> validate_required([:user, :workspace])
  end
end
