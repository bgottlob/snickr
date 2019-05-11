defmodule Snickr.Repo.Migrations.CreateMembershipinvitations do
  use Ecto.Migration

  def change do
    create table(:membershipinvitations) do
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :workspace_id, references(:workspaces, on_delete: :nothing)
      add :invited_by_user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:membershipinvitations, [:user_id])
    create index(:membershipinvitations, [:workspace_id])
    create index(:membershipinvitations, [:invited_by_user_id])
  end
end
