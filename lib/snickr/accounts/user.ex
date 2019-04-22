defmodule Snickr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :password_hash, :string, null: false
    field :salt, :string, null: false
    field :username, :string, null: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :email, :password_hash, :salt])
    |> validate_required([:username, :first_name, :last_name, :email, :password_hash, :salt])
  end
end
