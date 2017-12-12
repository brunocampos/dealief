defmodule Dealief.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    # enable citext PostgreSQL extension for email field
    execute "CREATE EXTENSION IF NOT EXISTS citext"
    create table(:users) do
      add :full_name, :string
      add :email, :citext
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
