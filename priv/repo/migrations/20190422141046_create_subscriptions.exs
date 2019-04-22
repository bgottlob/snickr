defmodule Snickr.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :user_id, references(:users, on_delete: :nothing), primary_key: true
      add :channel_id, references(:channels, on_delete: :nothing), primary_key: true

      timestamps(updated_at: false, type: :utc_datetime)
    end

    create index(:subscriptions, [:user_id])
    create index(:subscriptions, [:channel_id])
    create index(:subscriptions, [:user_id, :channel_id], unique: true)
  end
end
