defmodule Snickr.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password_hash, :string

      timestamps(type: :utc_datetime)
    end
    create index(:users, :username, unique: true)
    create index(:users, :email, unique: true)

  end
end
