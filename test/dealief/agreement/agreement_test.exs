defmodule Dealief.AgreementTest do
  use Dealief.DataCase

  alias Dealief.Agreement

  describe "vendors" do
    alias Dealief.Agreement.Vendor

    @valid_attrs %{category: "Telecommunications", name: "Vodafone"}
    @update_attrs %{category: "Media Provider", name: "Vodafone DE"}
    @invalid_attrs %{category: nil, name: nil}

    def vendor_fixture(attrs \\ %{}) do
      {:ok, vendor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Agreement.create_vendor()

      vendor
    end

    test "list_vendors/0 returns all vendors" do
      vendor = vendor_fixture()
      assert Agreement.list_vendors() == [vendor]
    end

    test "get_vendor!/1 returns the vendor with given id" do
      vendor = vendor_fixture()
      assert Agreement.get_vendor!(vendor.id) == vendor
    end

    test "create_vendor/1 with valid data creates a vendor" do
      assert {:ok, %Vendor{} = vendor} = Agreement.create_vendor(@valid_attrs)
      assert vendor.category == "Telecommunications"
      assert vendor.name == "Vodafone"
    end

    test "create_vendor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Agreement.create_vendor(@invalid_attrs)
    end

    test "update_vendor/2 with valid data updates the vendor" do
      vendor = vendor_fixture()
      assert {:ok, vendor} = Agreement.update_vendor(vendor, @update_attrs)
      assert %Vendor{} = vendor
      assert vendor.category == "Media Provider"
      assert vendor.name == "Vodafone DE"
    end

    test "update_vendor/2 with invalid data returns error changeset" do
      vendor = vendor_fixture()
      assert {:error, %Ecto.Changeset{}} = Agreement.update_vendor(vendor, @invalid_attrs)
      assert vendor == Agreement.get_vendor!(vendor.id)
    end

    test "delete_vendor/1 deletes the vendor" do
      vendor = vendor_fixture()
      assert {:ok, %Vendor{}} = Agreement.delete_vendor(vendor)
      assert_raise Ecto.NoResultsError, fn -> Agreement.get_vendor!(vendor.id) end
    end

    test "change_vendor/1 returns a vendor changeset" do
      vendor = vendor_fixture()
      assert %Ecto.Changeset{} = Agreement.change_vendor(vendor)
    end
  end

  describe "contracts" do
    alias Dealief.Agreement.Contract

    @valid_attrs %{details: "some details", ends_on: ~N[2010-04-17 14:00:00.000000], name: "some name", price: "120.5", starts_on: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{details: "some updated details", ends_on: ~N[2011-05-18 15:01:01.000000], name: "some updated name", price: "456.7", starts_on: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{details: nil, ends_on: nil, name: nil, price: nil, starts_on: nil}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Agreement.create_contract()

      contract
    end

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Agreement.list_contracts() == [contract]
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Agreement.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      assert {:ok, %Contract{} = contract} = Agreement.create_contract(@valid_attrs)
      assert contract.details == "some details"
      assert contract.ends_on == ~N[2010-04-17 14:00:00.000000]
      assert contract.name == "some name"
      assert contract.price == Decimal.new("120.5")
      assert contract.starts_on == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Agreement.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Agreement.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.details == "some updated details"
      assert contract.ends_on == ~N[2011-05-18 15:01:01.000000]
      assert contract.name == "some updated name"
      assert contract.price == Decimal.new("456.7")
      assert contract.starts_on == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_contract/2 with invalid data returns error changeset" do
      contract = contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Agreement.update_contract(contract, @invalid_attrs)
      assert contract == Agreement.get_contract!(contract.id)
    end

    test "delete_contract/1 deletes the contract" do
      contract = contract_fixture()
      assert {:ok, %Contract{}} = Agreement.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Agreement.get_contract!(contract.id) end
    end

    test "change_contract/1 returns a contract changeset" do
      contract = contract_fixture()
      assert %Ecto.Changeset{} = Agreement.change_contract(contract)
    end
  end
end
