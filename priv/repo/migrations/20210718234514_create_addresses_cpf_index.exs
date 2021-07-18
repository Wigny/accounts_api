defmodule Backend.Repo.Migrations.CreateAddressesCpfIndex do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:cpf])
  end
end
