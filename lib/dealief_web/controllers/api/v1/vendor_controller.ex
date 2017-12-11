defmodule DealiefWeb.Api.V1.VendorController do
  use DealiefWeb, :controller

  alias Dealief.Agreement

  action_fallback DealiefWeb.FallbackController

  def index(conn, _params) do
    vendors = Agreement.list_vendors()
    render(conn, "index.json", vendors: vendors)
  end

  def show(conn, %{"id" => id}) do
    vendor = Agreement.get_vendor!(id)
    render(conn, "show.json", vendor: vendor)
  end

end
