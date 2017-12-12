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
      vendor: contract.vendor.name,
      user: contract.user.full_name,
      details: contract.details,
      starts_on: format_date(contract.starts_on),
      ends_on: format_date(contract.ends_on),
      price: contract.price}
  end

  defp format_date(date), do: "#{date.day}-#{date.month}-#{date.year}"

end
