defmodule DealiefWeb.Api.V1.ContractView do
  use DealiefWeb, :view
  alias DealiefWeb.Api.V1.ContractView

  def render("index.json", %{contracts: contracts}) do
    %{data: render_many(contracts, ContractView, "contract.json")}
  end

  def render("show.json", %{contract: contract}) do
    %{data: render_one(contract, ContractView, "contract.json")}
  end

  def render("contract.json", %{contract: contract}) do
    %{id: contract.id,
      name: contract.name,
      details: contract.details,
      starts_on: contract.starts_on,
      ends_on: contract.ends_on,
      price: contract.price}
  end
end
