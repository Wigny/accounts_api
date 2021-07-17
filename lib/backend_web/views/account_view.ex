defmodule BackendWeb.AccountView do
  use BackendWeb, :view
  alias BackendWeb.{AccountView, AddressView}

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      name: account.name,
      cpf: account.cpf,
      address: render_one(account.address, AddressView, "address.json")
    }
  end
end
