defmodule DealiefWeb.Api.V1.VendorControllerTest do
  use DealiefWeb.ConnCase

  alias Dealief.Agreement

  @create_attrs %{category: "Telecommunications", name: "Vodafone"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vendors", %{conn: conn} do
      conn = get conn, api_v1_vendor_path(conn, :index)

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "show a vendor by id", %{conn: conn} do
      {:ok, vendor} = Agreement.create_vendor(@create_attrs)
      conn = get conn, api_v1_vendor_path(conn, :show, vendor.id)

      assert json_response(conn, 200)["data"] == %{
        "id" => vendor.id,
        "name" => vendor.name,
        "category" => vendor.category}
    end      
  end

end
