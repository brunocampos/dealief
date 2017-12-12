defmodule Dealief.AgreementTest do
  use Dealief.DataCase

  alias Dealief.Agreement
  alias Dealief.Account

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
    alias Dealief.Agreement.ContractDate

    @valid_attrs %{details: "4G - unlimited", ends_on: "10-11-2018", name: "Vodafone 4G", price: "25.99", starts_on: "23-02-2016" }
    @update_attrs %{details: "5G - unlimited", ends_on: "10-11-2020", name: "Vodafone 5G", price: "27.99", starts_on: "01-01-2018"}
    @invalid_attrs %{details: nil, ends_on: nil, name: nil, price: nil, starts_on: nil}
    @user_attrs %{email: "john_smith@example.com", full_name: "John Smith", password: "secret"}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Agreement.create_contract()

      contract
    end

    def parse_date(date) do
      {:ok, date} = ContractDate.cast(date)
      date
    end

    def user_fixture() do
      {:ok, user} = Account.create_user(@user_attrs)
      user
    end

    def contract_associations() do
      user = user_fixture()
      vendor = vendor_fixture()
      %{user_id: user.id, vendor_id: vendor.id}
    end    

    test "list_contracts/0 returns all contracts" do
      contract = contract_associations() |> contract_fixture()

      assert Agreement.list_contracts() == [contract]
    end

    test "list_user_contracts/1 returns only contracts from specified user" do
      user = user_fixture()
      vendor = vendor_fixture()
      user_contract = contract_fixture(%{user_id: user.id, vendor_id: vendor.id}) |> Repo.preload(:vendor) |> Repo.preload(:user)
      
      {:ok, other_user} = Account.create_user(%{email: "matthias@example.com", full_name: "Matthias Meyer", password: "othersecret"})
      {:ok, other_vendor} = Agreement.create_vendor(%{"name" => "Netflix", "category" => "Media"})
      other_contract_attrs = %{details: "Netflix HD Plan", ends_on: "24-05-2021", name: "Netflix HD", price: "19.99", starts_on: "01-08-2017", user_id: other_user.id, vendor_id: other_vendor.id }
      {:ok, other_user_contract} = Agreement.create_contract(other_contract_attrs)

      refute Agreement.list_user_contracts(user.id) == [user_contract, other_user_contract]
      assert Agreement.list_user_contracts(user.id) == [user_contract]
    end
    
    test "get_user_contract/1 returns a contract with given contract id and user id " do
      user = user_fixture()
      vendor = vendor_fixture()
      user_contract = contract_fixture(%{user_id: user.id, vendor_id: vendor.id}) |> Repo.preload(:vendor) |> Repo.preload(:user)

      assert {:ok, ^user_contract} = Agreement.get_user_contract(user_contract.id, user.id)
    end    

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_associations() |> contract_fixture()

      assert Agreement.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      attrs = Map.merge(@valid_attrs, contract_associations())

      assert {:ok, %Contract{} = contract} = Agreement.create_contract(attrs)
      assert contract.details == @valid_attrs.details
      assert contract.ends_on == parse_date(@valid_attrs.ends_on)
      assert contract.name == @valid_attrs.name
      assert contract.price == Decimal.new(@valid_attrs.price)
      assert contract.starts_on == parse_date(@valid_attrs.starts_on)
    end

    test "create_contract/1 with invalid data returns error changeset" do
      attrs = Map.merge(@invalid_attrs, contract_associations())

      assert {:error, %Ecto.Changeset{}} = Agreement.create_contract(attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      associations_attrs = contract_associations()
      contract = contract_fixture(associations_attrs)
      attrs = Map.merge(@update_attrs, associations_attrs)

      assert {:ok, contract} = Agreement.update_contract(contract,attrs)
      assert %Contract{} = contract
      assert contract.details == @update_attrs.details
      assert contract.ends_on == parse_date(@update_attrs.ends_on)
      assert contract.name == @update_attrs.name
      assert contract.price == Decimal.new(@update_attrs.price)
      assert contract.starts_on == parse_date(@update_attrs.starts_on)
    end

    test "update_contract/2 with invalid data returns error changeset" do
      associations_attrs = contract_associations()
      contract = contract_fixture(associations_attrs)
      attrs = Map.merge(@invalid_attrs, associations_attrs)

      assert {:error, %Ecto.Changeset{}} = Agreement.update_contract(contract, attrs)
      assert contract == Agreement.get_contract!(contract.id)
    end

    test "delete_contract/1 deletes the contract" do
      contract = contract_associations() |> contract_fixture()

      assert {:ok, %Contract{}} = Agreement.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Agreement.get_contract!(contract.id) end
    end

    test "change_contract/1 returns a contract changeset" do
      contract = contract_associations() |> contract_fixture()

      assert %Ecto.Changeset{} = Agreement.change_contract(contract)
    end
  end
end
