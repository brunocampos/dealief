defmodule DealiefWeb.Api.V1.VendorView do
  use DealiefWeb, :view
  alias DealiefWeb.Api.V1.VendorView

  def render("index.json", %{vendors: vendors}) do
    %{data: render_many(vendors, VendorView, "vendor.json")}
  end

  def render("show.json", %{vendor: vendor}) do
    %{data: render_one(vendor, VendorView, "vendor.json")}
  end

  def render("vendor.json", %{vendor: vendor}) do
    %{id: vendor.id,
      name: vendor.name,
      category: vendor.category}
  end
end
