defmodule Backend.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts.{Account, Address}

  def list_accounts do
    Repo.all(Account)
  end

  def get_account(id) do
    Account
    |> preload(:address)
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs, action: :update)
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end
end
