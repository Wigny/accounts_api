defmodule Backend.Accounts.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :city, :string
    field :complement, :string
    field :neighborhood, :string
    field :number, :integer
    field :postal_code, :string
    field :state, :string
    field :street, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    fields = ~w(street number complement neighborhood city state postal_code)a

    address
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
