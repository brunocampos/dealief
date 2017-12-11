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
end
