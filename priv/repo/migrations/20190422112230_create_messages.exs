defmodule Snickr.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :sent_by_user_id, references(:users, on_delete: :nothing), primary_key: true
      add :channel_id, references(:channels, on_delete: :delete_all), pimrary_key: true
      add :inserted_at, :utc_datetime_usec, primary_key: true

      add :content, :text
      add :edited, :boolean, default: false, null: false
      timestamps(type: :utc_datetime_usec, inserted_at: false)
    end

    create index(:messages, [:sent_by_user_id, :channel_id, :inserted_at], unique: true)

    create index(:messages, [:channel_id])
    create index(:messages, [:sent_by_user_id])
  end
end
