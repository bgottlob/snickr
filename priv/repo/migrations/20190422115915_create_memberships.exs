defmodule Snickr.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :workspace_id, references(:workspaces, on_delete: :delete_all), primary_key: true

      timestamps(updated_at: false, type: :utc_datetime)
    end

    create index(:memberships, [:user_id])
    create index(:memberships, [:workspace_id])
    create index(:memberships, [:user_id, :workspace_id], unique: true)
  end
end
