defmodule DealiefWeb.Api.V1.ContractController do
  use DealiefWeb, :controller

  alias Dealief.Repo
  alias Dealief.Agreement
  alias Dealief.Agreement.Contract

  action_fallback DealiefWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns.current_user_id
    contracts = Agreement.list_user_contracts(user_id)
    render(conn, "index.json", contracts: contracts)
  end

  def create(conn, %{"contract" => contract_params}) do
    user_id = conn.assigns.current_user_id
    contract_params = Map.merge(contract_params, %{"user_id" => user_id})
    with {:ok, %Contract{} = contract} <- Agreement.create_contract(contract_params) do
      contract = contract
      |> Repo.preload(:vendor)
      |> Repo.preload(:user)      

      conn
      |> put_status(:created)
      |> put_resp_header("location", api_v1_contract_path(conn, :show, contract))
      |> render("show.json", contract: contract)
    end
  end

  def show(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user_id
    with {:ok, %Contract{} = contract} <- Agreement.get_user_contract(id, user_id) do
      render(conn, "show.json", contract: contract)
    end 
  end

  def update(conn, %{"id" => id, "contract" => contract_params}) do
    user_id = conn.assigns.current_user_id
    with {:ok, %Contract{} = contract} <- Agreement.get_user_contract(id, user_id),
         {:ok, %Contract{} = contract} <- Agreement.update_contract(contract, contract_params) do
      render(conn, "show.json", contract: contract)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user_id  
    with {:ok, %Contract{} = contract} <- Agreement.get_user_contract(id, user_id),
         {:ok, %Contract{}} <- Agreement.delete_contract(contract) do
      send_resp(conn, :no_content, "")
    end
  end
end
