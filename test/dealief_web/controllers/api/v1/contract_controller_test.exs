defmodule DealiefWeb.Api.V1.ContractControllerTest do
  use DealiefWeb.ConnCase
  import DealiefWeb.ControllerHelper

  alias Dealief.Repo
  alias Dealief.Agreement
  alias Dealief.Agreement.Contract
  alias Dealief.Account

  @create_attrs %{details: "4G - unlimited", ends_on: "10-11-2018", name: "Vodafone 4G", price: "25.99", starts_on: "23-02-2016" }
  @update_attrs %{details: "5G - unlimited", ends_on: "10-11-2020", name: "Vodafone 5G", price: "27.99", starts_on: "01-01-2018"}
  @invalid_attrs %{details: nil, ends_on: nil, name: nil, price: nil, starts_on: nil}
  @user_attrs %{email: "john_smith@example.com", full_name: "John Smith", password: "secret"}
  @other_user_attrs %{email: "anna@example.com", full_name: "Anna Logan", password: "secret"}
  @vendor_attrs %{category: "Telecommunications", name: "Vodafone"}

  def contract_fixture(attrs \\ %{}) do
    {:ok, contract} =
      attrs
      |> Enum.into(@create_attrs)
      |> Agreement.create_contract()
      
    contract
    |> Repo.preload(:user)
    |> Repo.preload(:vendor)   
  end

  def vendor_fixture(attrs \\ @vendor_attrs) do
    {:ok, vendor} = Agreement.create_vendor(attrs)
    vendor    
  end

  def user_fixture(attrs \\ @user_attrs) do
    {:ok, user} = Account.create_user(attrs)
    user
  end

  setup %{conn: conn} do
    user = user_fixture(@user_attrs)
    token = "Bearer " <> generate_user_token(user.id)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", token)
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, api_v1_contract_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create contract" do
    test "renders contract when data is valid", %{conn: conn, user: user} do
      vendor = vendor_fixture()
      attrs = Map.merge(@create_attrs, %{user_id: user.id, vendor_id: vendor.id})
      conn = post conn, api_v1_contract_path(conn, :create), contract: attrs
      contract_name = @create_attrs.name

      assert %{"name" => ^contract_name} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: _user} do
      conn = post conn, api_v1_contract_path(conn, :create), contract: @invalid_attrs

      assert json_response(conn, 422)["errors"] != %{}
    end
  end


  describe "update contract" do
    setup [:create_contract]

    test "renders contract when logged user owns the contract and data is valid", %{conn: conn, user: user, contract: %Contract{id: id} = contract} do
      conn = put conn, api_v1_contract_path(conn, :update, contract), contract: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
      assert user.id == contract.user_id
      assert user.id == conn.assigns.current_user_id
    end

    test "renders errors when logged user owns the but contract data is invalid", %{conn: conn, user: user, contract: contract} do
      conn = put conn, api_v1_contract_path(conn, :update, contract), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
      assert user.id == contract.user_id
      assert user.id == conn.assigns.current_user_id
    end

    test "renders error when logged user tries to update contract with other owner", %{conn: conn, user: user, vendor: vendor} do
      other_user = user_fixture(@other_user_attrs)
      other_user_contract = contract_fixture(%{user_id: other_user.id, vendor_id: vendor.id})
      conn = put conn, api_v1_contract_path(conn, :update, other_user_contract), contract: @update_attrs

      refute user.id == other_user.id
      assert json_response(conn, 404)["error"] == "Contract not found"      
    end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract when user is the owner", %{conn: conn, user: user, contract: contract} do
      assert user.id == contract.user_id

      conn = delete conn, api_v1_contract_path(conn, :delete, contract)
      
      assert user.id == conn.assigns.current_user_id
      assert response(conn, 204) 
    end

    test "renders error when logged user tries to delete contract with other owner", %{conn: conn, user: user, vendor: vendor} do
      other_user = user_fixture(@other_user_attrs)
      other_user_contract = contract_fixture(%{user_id: other_user.id, vendor_id: vendor.id})
      conn = delete conn, api_v1_contract_path(conn, :delete, other_user_contract)

      refute user.id == other_user.id
      assert json_response(conn, 404)["error"] == "Contract not found"
    end

  end

  defp create_contract(context) do
    vendor = vendor_fixture()
    contract = contract_fixture(%{user_id: context.user.id, vendor_id: vendor.id})
    {:ok, contract: contract, vendor: vendor}
  end
end
