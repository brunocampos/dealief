defmodule DealiefWeb.Api.V1.UserControllerTest do
  use DealiefWeb.ConnCase
  import DealiefWeb.ControllerHelper

  alias Dealief.Account
  alias Dealief.Account.User

  @create_attrs %{email: "john@example.com", full_name: "John", password: "password"}
  @update_attrs %{email: "john_smith@example.com", full_name: "John Smith", password: "updated_password"}
  @invalid_attrs %{email: nil, full_name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, api_v1_user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user and token when data is valid", %{conn: conn} do      
      conn = post conn, api_v1_user_path(conn, :create), user: @create_attrs
      email = @create_attrs.email
      full_name = @create_attrs.full_name
      
      assert %{"id" => id, "token" => token,
      "email" => ^email, "full_name" => ^full_name} = json_response(conn, 201)["data"]
      assert {:ok, ^id} = verify_user_token(token)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_user_path(conn, :create), user: @invalid_attrs
      
      assert json_response(conn, 422)["errors"] == %{
        "email" => ["should not be empty"],
        "full_name" => ["should not be empty"],
        "password" => ["should not be empty"]
      }      
    end

    test "render error when user tries to register with an existing email", %{conn: conn} do
      fixture(:user)    
      conn = post conn, api_v1_user_path(conn, :create), user: @create_attrs

      assert json_response(conn, 422)["errors"] == %{
        "email" => ["has already been taken"]
      }
    end    
  end

  describe "update user" do
    setup [:create_user]

    test "renders user and token when data is valid", %{conn: conn, user: %User{id: id} = user} do      
      conn = put conn, api_v1_user_path(conn, :update, user), user: @update_attrs
      email = @update_attrs.email
      full_name = @update_attrs.full_name

      assert %{"id" => ^id, "token" => token,
      "email" => ^email, "full_name" => ^full_name} = json_response(conn, 200)["data"]
      assert {:ok, ^id} = verify_user_token(token)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, api_v1_user_path(conn, :update, user), user: @invalid_attrs

      assert json_response(conn, 422)["errors"] == %{
        "email" => ["should not be empty"],
        "full_name" => ["should not be empty"],
        "password" => ["should not be empty"]
      }
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, api_v1_user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
