defmodule Snickr.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces) do
      add :name, :string
      add :description, :string
      add :created_by_user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:workspaces, [:created_by_user_id])
  end
end
