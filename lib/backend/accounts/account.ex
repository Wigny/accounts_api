defmodule Backend.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Accounts.Address

  schema "accounts" do
    field :cpf, :string
    field :name, :string
    has_one :address, Address, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(account \\ %__MODULE__{}, attrs \\ %{}, opts \\ [action: :insert])

  def changeset(account, attrs, action: :insert) do
    changeset =
      account
      |> cast(attrs, [:cpf, :name])
      |> cast_assoc(:address)
      |> validate_required([:cpf, :name])
      |> validate_length(:cpf, is: 11)
      |> unique_constraint(:cpf)

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
