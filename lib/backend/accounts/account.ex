defmodule Backend.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Accounts.Address

  schema "accounts" do
    field :cpf, :string
    field :name, :string
    belongs_to :address, Address, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(account, attrs, opts \\ [action: :insert])

  def changeset(account, attrs, action: :insert) do
    changeset =
      account
      |> cast(attrs, [:name, :cpf])
      |> cast_assoc(:address)
      |> validate_required([:name, :cpf])
      |> validate_length(:cpf, is: 11)

    %{changeset | action: :insert}
  end

  @doc false
  def changeset(account, attrs, action: :update) do
    changeset =
      account
      |> cast(attrs, [:name])
      |> cast_assoc(:address, with: &Address.changeset(%Address{id: &1.id}, &2))

    %{changeset | action: :update}
  end
end
