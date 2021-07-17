defmodule Backend.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :cpf, :string
      add :address_id, references(:addresses, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts, [:address_id])
  end
end
