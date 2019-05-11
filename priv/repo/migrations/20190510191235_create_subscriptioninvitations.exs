defmodule Snickr.Repo.Migrations.CreateSubscriptioninvitations do
  use Ecto.Migration

  def change do
    create table(:subscriptioninvitations) do
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :channel_id, references(:channels, on_delete: :nothing)
      add :invited_by_user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:subscriptioninvitations, [:user_id])
    create index(:subscriptioninvitations, [:channel_id])
    create index(:subscriptioninvitations, [:invited_by_user_id])
  end
end
