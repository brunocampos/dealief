defmodule DealiefWeb.Api.V1.AuthController do
  use DealiefWeb, :controller
  import DealiefWeb.ControllerHelper

  alias Dealief.Account

  def create(conn, %{"user" => user_params}) do
    case Account.login_user(%{"email" => user_params["email"], "password" => user_params["password"]}) do
      {:ok, user} ->
        token = generate_user_token(user.id)
        conn
        |> json(%{data: %{id: user.id, email: user.email, full_name: user.full_name, token: token}})

      {:error, reason} ->
        conn
        |> put_status(401)
        |> json(%{error: reason})
    end  
  end  
end
