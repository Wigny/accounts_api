defmodule Backend.AccountsTest do
  use Backend.DataCase

  alias Backend.Accounts

  describe "accounts" do
    alias Backend.Accounts.Account

    @valid_attrs %{
      name: "Wígny Almeida",
      cpf: "04543413261",
      address: %{
        postal_code: "76907-372"
      }
    }
    @invalid_attrs %{cpf: nil, name: nil, address: %{}}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.cpf == "04543413261"
      assert account.name == "Wígny Almeida"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
