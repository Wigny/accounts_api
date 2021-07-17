defmodule Backend.Repo.Migrations.AlterAccounts do
  use Ecto.Migration

  def change do
    drop index(:accounts, [:address_id])

    alter table(:accounts) do
      remove :address_id, references(:addresses, on_delete: :nothing)
    end

    alter table(:addresses) do
      add :account_id, references(:accounts, on_delete: :delete_all)
    end

    create index(:addresses, [:account_id])
  end
end
