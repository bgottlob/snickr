defmodule Snickr.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :workspace_id, references(:workspaces, on_delete: :delete_all), primary_key: true

      timestamps(updated_at: false, type: :utc_datetime)
    end

    create index(:admins, [:user_id])
    create index(:admins, [:workspace_id])
    create index(:admins, [:user_id, :workspace_id], unique: true)
  end
end
