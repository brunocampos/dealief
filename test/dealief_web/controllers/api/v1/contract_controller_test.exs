defmodule DealiefWeb.Api.V1.ContractControllerTest do
  use DealiefWeb.ConnCase

  alias Dealief.Agreement
  alias Dealief.Agreement.Contract

  @create_attrs %{details: "some details", ends_on: ~N[2010-04-17 14:00:00.000000], name: "some name", price: "120.5", starts_on: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{details: "some updated details", ends_on: ~N[2011-05-18 15:01:01.000000], name: "some updated name", price: "456.7", starts_on: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{details: nil, ends_on: nil, name: nil, price: nil, starts_on: nil}

  def fixture(:contract) do
    {:ok, contract} = Agreement.create_contract(@create_attrs)
    contract
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, api_v1_contract_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create contract" do
    test "renders contract when data is valid", %{conn: conn} do
      conn = post conn, api_v1_contract_path(conn, :create), contract: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "details" => "some details",
        "ends_on" => NaiveDateTime.to_iso8601(~N[2010-04-17 14:00:00.000000]),
        "name" => "some name",
        "price" => "120.5",
        "starts_on" => NaiveDateTime.to_iso8601(~N[2010-04-17 14:00:00.000000])}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_contract_path(conn, :create), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contract" do
    setup [:create_contract]

    test "renders contract when data is valid", %{conn: conn, contract: %Contract{id: id} = contract} do
      conn = put conn, api_v1_contract_path(conn, :update, contract), contract: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "details" => "some updated details",
        "ends_on" => NaiveDateTime.to_iso8601(~N[2011-05-18 15:01:01.000000]),
        "name" => "some updated name",
        "price" => "456.7",
        "starts_on" => NaiveDateTime.to_iso8601(~N[2011-05-18 15:01:01.000000])}
    end

    test "renders errors when data is invalid", %{conn: conn, contract: contract} do
      conn = put conn, api_v1_contract_path(conn, :update, contract), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract", %{conn: conn, contract: contract} do
      conn = delete conn, api_v1_contract_path(conn, :delete, contract)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_contract_path(conn, :show, contract)
      end
    end
  end

  defp create_contract(_) do
    contract = fixture(:contract)
    {:ok, contract: contract}
  end
end
