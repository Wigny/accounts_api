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
    field :account_id, :id

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    requireds = ~w(street neighborhood city state postal_code)a
    fields = requireds ++ ~w(number complement)a

    address
    |> cast(attrs, fields)
    |> put_requireds()
    |> validate_required(requireds)
    |> validate_length(:state, is: 2)
    |> validate_format(:postal_code, ~r/^\d{5}-\d{3}$/)
  end

  defp put_requireds(changeset) do
    changeset
    |> apply_changes()
    |> update_address(changeset)
  end

  defp update_address(%{postal_code: nil} = changes, changeset)
       when not is_nil(changes.state) and
              not is_nil(changes.city) and
              not is_nil(changes.street) and
              not is_nil(changes.neighborhood) do
    case Backend.ViaCEP.postal_code(changes.state, changes.city, changes.street) do
      {:ok, %{status: 200, body: body}} when body != [] ->
        %{cep: cep} =
          Enum.max_by(body, fn addrs ->
            String.jaro_distance(addrs.logradouro, changes.street) +
              String.jaro_distance(addrs.bairro, changes.neighborhood)
          end)

        put_change(changeset, :postal_code, cep)

      {_status, _env} ->
        add_error(changeset, :postal_code, "is invalid", additional: "not found")
    end
  end

  defp update_address(%{postal_code: postal_code} = changes, changeset)
       when is_nil(changes.state) or
              is_nil(changes.city) or
              is_nil(changes.street) or
              is_nil(changes.neighborhood) do
    case Backend.ViaCEP.address(postal_code) do
      {:ok, %{status: 200, body: %{cep: _cep} = body}} ->
        changeset
        |> put_change(:street, body.logradouro)
        |> put_change(:complement, body.complemento)
        |> put_change(:neighborhood, body.bairro)
        |> put_change(:city, body.localidade)
        |> put_change(:state, body.uf)

      {_status, _error} ->
        add_error(changeset, :postal_code, "is invalid")
    end
  end

  defp update_address(_changes, changeset), do: changeset
end
