defmodule DealiefWeb.Plugs.ApiAuthorizeUserTest do
  use DealiefWeb.ConnCase
  import DealiefWeb.ControllerHelper

  alias Dealief.Account

  @create_attrs %{email: "john@example.com", full_name: "John", password: "password"}
  
  test "allow access to restricted paths when user is authenticated with valid token" do
    {:ok, user} = Account.create_user(@create_attrs)
    token = generate_user_token(user.id)
    conn = build_conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> token)
    |> get("api/v1/contracts")
    
    assert conn.status == 200
    assert user.id == conn.assigns.current_user_id
  end

  test "forbids access on restricted paths to anonymous users" do
    conn = build_conn()
    |> put_req_header("accept", "application/json")
    |> get("api/v1/contracts")

    assert conn.status == 403
  end

end