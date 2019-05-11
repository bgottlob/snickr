defmodule Snickr.Repo.Migrations.CreateAdmininvitations do
  use Ecto.Migration

  def change do
    create table(:admininvitations) do
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :workspace_id, references(:workspaces, on_delete: :nothing)
      add :invited_by_user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:admininvitations, [:user_id])
    create index(:admininvitations, [:workspace_id])
    create index(:admininvitations, [:invited_by_user_id])
  end
end
