defmodule Snickr.Platform.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Accounts.User
  alias Snickr.Platform.Channel

  @primary_key false
  schema "messages" do
    # TODO Figure out how to make inserted_at marked as a primary key here
    # while still having it autopopulate
    # field :inserted_at, :utc_datetime_usec, primary_key: true
    belongs_to :channel, Channel, primary_key: true
    belongs_to :sent_by_user, User, primary_key: true

    field :content, :string
    field :edited, :boolean, default: false

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :edited])
    |> validate_required([:content, :edited])
  end
end
