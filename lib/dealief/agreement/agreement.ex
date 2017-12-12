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

  alias Dealief.Agreement.Contract

  def list_contracts do
    Repo.all(Contract)
  end

  def list_user_contracts(user_id) do
    Contract
    |> where(user_id: ^user_id)
    |> preload(:user)
    |> preload(:vendor)
    |> Repo.all
  end
  
  def get_contract!(id), do: Repo.get!(Contract, id)

  def get_user_contract(contract_id, user_id) do
    Contract
    |> where(id: ^contract_id)
    |> where(user_id: ^user_id)
    |> preload(:vendor)
    |> preload(:user)
    |> Repo.one()
    |> case  do
      nil -> {:error, :not_found, "Contract not found"}
      contract -> {:ok, contract}
    end
  end  

  def create_contract(attrs \\ %{}) do
    %Contract{}
    |> Contract.changeset(attrs)
    |> Repo.insert()
  end

  def update_contract(%Contract{} = contract, attrs) do
    contract
    |> Contract.changeset(attrs)
    |> Repo.update()
  end

  def delete_contract(%Contract{} = contract) do
    Repo.delete(contract)
  end

  def change_contract(%Contract{} = contract) do
    Contract.changeset(contract, %{})
  end
end
