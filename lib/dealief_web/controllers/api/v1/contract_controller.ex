defmodule DealiefWeb.Api.V1.ContractController do
  use DealiefWeb, :controller

  alias Dealief.Agreement
  alias Dealief.Agreement.Contract

  action_fallback DealiefWeb.FallbackController

  def index(conn, _params) do
    contracts = Agreement.list_contracts()
    render(conn, "index.json", contracts: contracts)
  end

  def create(conn, %{"contract" => contract_params}) do
    with {:ok, %Contract{} = contract} <- Agreement.create_contract(contract_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_v1_contract_path(conn, :show, contract))
      |> render("show.json", contract: contract)
    end
  end

  def show(conn, %{"id" => id}) do
    contract = Agreement.get_contract!(id)
    render(conn, "show.json", contract: contract)
  end

  def update(conn, %{"id" => id, "contract" => contract_params}) do
    contract = Agreement.get_contract!(id)

    with {:ok, %Contract{} = contract} <- Agreement.update_contract(contract, contract_params) do
      render(conn, "show.json", contract: contract)
    end
  end

  def delete(conn, %{"id" => id}) do
    contract = Agreement.get_contract!(id)
    with {:ok, %Contract{}} <- Agreement.delete_contract(contract) do
      send_resp(conn, :no_content, "")
    end
  end
end
