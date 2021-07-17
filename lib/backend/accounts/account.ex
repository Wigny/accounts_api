defmodule Backend.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Accounts.Address

  schema "accounts" do
    field :cpf, :string
    field :name, :string
    belongs_to :address, Address

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :cpf])
    |> cast_assoc(:address, with: &Address.changeset/2)
    |> validate_required([:name, :cpf])
    |> validate_length(:cpf, is: 11)
  end
end
