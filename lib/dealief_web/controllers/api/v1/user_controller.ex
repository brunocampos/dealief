defmodule DealiefWeb.Api.V1.UserController do
  use DealiefWeb, :controller
  import DealiefWeb.ControllerHelper

  alias Dealief.Account
  alias Dealief.Account.User

  action_fallback DealiefWeb.FallbackController

  plug :resource_ownership when action in [:show, :update, :delete]

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      token = generate_user_token(user.id)      
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_v1_user_path(conn, :show, user))
      |> render("show.json", user: user, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      token = generate_user_token(user.id)
      render(conn, "show.json", user: user, token: token)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp resource_ownership(conn, _) do
    if conn.assigns.current_user_id != String.to_integer(conn.params["id"]) do
      conn
      |> put_status(404)
      |> json(%{error: "User not found"})
      |> halt
    else
      conn
    end
  end
end
