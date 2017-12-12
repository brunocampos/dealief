defmodule DealiefWeb.Api.V1.AuthControllerTest do
  use DealiefWeb.ConnCase
  import DealiefWeb.ControllerHelper

  alias Dealief.Account

  @create_attrs %{email: "john@example.com", full_name: "John", password: "password"}
  @invalid_attrs %{email: "invalid@example.com", password: "invalidpass"}

  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user and token when credentials are valid", %{conn: conn} do
      user = fixture(:user)
      conn = post conn, api_v1_auth_path(conn, :create),
        user: %{"email" => user.email, "password" => user.password}

      assert %{"id" => id, "token" => token} = json_response(conn, 200)["data"]
      assert {:ok, ^id} = verify_user_token(token)       
    end

    test "renders error when credentials is invalid", %{conn: conn} do
      conn = post conn, api_v1_auth_path(conn, :create), user: @invalid_attrs

      assert json_response(conn, 401)["error"] == "Invalid login"
    end
  end  

  
end