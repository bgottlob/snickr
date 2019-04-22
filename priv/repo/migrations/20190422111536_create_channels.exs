defmodule Snickr.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string
      add :description, :string
      add :type, :string
      add :created_by_user_id, references(:users, on_delete: :nothing)
      add :workspace_id, references(:workspaces, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:channels, [:created_by_user_id])
    create index(:channels, [:workspace_id])
  end
end
