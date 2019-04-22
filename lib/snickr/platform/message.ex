defmodule Snickr.Platform.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snickr.Accounts.User
  alias Snickr.Platform.Channel

  @primary_key false
  schema "messages" do
    field :inserted_at, :utc_datetime_usec, primary_key: true
    belongs_to :channel, Channel, primary_key: true
    belongs_to :sent_by_user, User, primary_key: true

    field :content, :string
    field :edited, :boolean, default: false

    timestamps(type: :utc_datetime_usec, inserted_at: false)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :edited])
    |> validate_required([:content, :edited])
  end
end
