defmodule Dealief.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :name, :string
      add :details, :text
      add :starts_on, :naive_datetime
      add :ends_on, :naive_datetime
      add :price, :decimal
      add :vendor_id, references(:vendors, on_delete: :nilify_all)
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:contracts, [:vendor_id])
    create index(:contracts, [:user_id])
  end
end
