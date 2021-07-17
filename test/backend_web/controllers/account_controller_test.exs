defmodule BackendWeb.AccountControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Accounts
  alias Backend.Accounts.Account

  @create_attrs %{
    name: "Wígny Almeida",
    cpf: "04543413261",
    address: %{
      postal_code: "76907-372"
    }
  }

  @update_attrs %{cpf: "", address: %{postal_code: "76900-121"}}

  @invalid_attrs %{cpf: nil, name: nil, address: %{}}

  def fixture(:account) do
    {:ok, account} = Accounts.create_account(@create_attrs)
    account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => "04543413261",
               "name" => "Wígny Almeida",
               "address" => %{
                 "state" => "RO",
                 "city" => "Ji-Paraná",
                 "neighborhood" => "São Bernardo"
               }
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account" do
    setup [:create_account]

    test "renders account when data is valid", %{
      conn: conn,
      account: %Account{id: id, cpf: cpf} = account
    } do
      conn = put(conn, Routes.account_path(conn, :update, account), account: @update_attrs)
      assert %{"id" => ^id, "cpf" => ^cpf} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => cpf,
               "address" => %{"neighborhood" => "Centro"}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      conn = put(conn, Routes.account_path(conn, :update, account), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account" do
    setup [:create_account]

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete(conn, Routes.account_path(conn, :delete, account))
      assert response(conn, 204)

      conn = get(conn, Routes.account_path(conn, :show, account))
      assert response(conn, 404)
    end
  end

  defp create_account(_) do
    account = fixture(:account)
    %{account: account}
  end
end
