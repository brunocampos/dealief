defmodule DealiefWeb.Plugs.ApiAuthorizeUser do
  @moduledoc """
  Plug to validate authentication token
  """
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  import DealiefWeb.ControllerHelper

  def init(_opts), do: nil

  def call(conn, _opts) do    
    case get_req_header(conn, "authorization") do
      [] -> 
        conn
        |> put_status(403)
        |> json(%{error: "Authorization neeeded."})
        |> halt
        
      [authorization | _ ] ->
        token = String.replace(authorization,"Bearer ", "")
        case verify_user_token(token) do
          {:ok, user_id} ->
            conn
            |> assign(:current_user_id, user_id)
          
          {:error, reason} ->
            conn
            |> put_status(403)
            |> json(%{error: Atom.to_string(reason)})
            |> halt  
        end         
    end
  end

end
