defmodule Dealief.Agreement do
  @moduledoc """
  The Agreement context.
  """

  import Ecto.Query, warn: false
  alias Dealief.Repo

  alias Dealief.Agreement.Vendor

  def list_vendors do
    Repo.all(Vendor)
  end

  def get_vendor!(id), do: Repo.get!(Vendor, id)

  def create_vendor(attrs \\ %{}) do
    %Vendor{}
    |> Vendor.changeset(attrs)
    |> Repo.insert()
  end

  def update_vendor(%Vendor{} = vendor, attrs) do
    vendor
    |> Vendor.changeset(attrs)
    |> Repo.update()
  end

  def delete_vendor(%Vendor{} = vendor) do
    Repo.delete(vendor)
  end

  def change_vendor(%Vendor{} = vendor) do
    Vendor.changeset(vendor, %{})
  end
end
