# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dealief.Repo.insert!(%Dealief.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dealief.Account
alias Dealief.Agreement

users = [
  %{"email" => "john_smith@example.com", "full_name" => "John Smith", "password" => "password1"},
  %{"email" => "anna@example.com", "full_name" => "Anna Logan", "password" => "password2"},
  %{"email" => "matthias@example.com", "full_name" => "Matthias Meyer", "password" => "password3"}
]

Enum.each(users, fn(user) -> Account.create_user(user) end)

vendors = [
  %{"name" => "O2", "category" => "Telecommunications"},
  %{"name" => "Vodafone", "category" => "Telecommunications"},
  %{"name" => "Verizon", "category" => "Telecommunications"},
  %{"name" => "Allianz", "category" => "Insurance"},
  %{"name" => "Netflix", "category" => "Media"}
]

Enum.each(vendors, fn(vendor) -> Agreement.create_vendor(vendor) end)

contracts = [
  %{details: "5G - unlimited", ends_on: "10-11-2018", name: "O2 5G",
    price: "29.99", starts_on: "12-04-2017", user_id: 1, vendor_id: 1},
  %{details: "4G - unlimited", ends_on: "10-02-2018", name: "Vodafone 4G",
    price: "25.99", starts_on: "23-02-2016", user_id: 2, vendor_id: 2},
  %{details: "Verizon full plan", ends_on: "27-08-2018", name: "Verizon 5G",
    price: "25.99", starts_on: "15-05-2016", user_id: 3, vendor_id: 3},
  %{details: "Netflix 4K", ends_on: "27-04-2020", name: "Netflix 4k",
    price: "19.50", starts_on: "03-06-2016", user_id: 1, vendor_id: 5},
  %{details: "Netflix 4K", ends_on: "17-02-2019", name: "Netflix 4k",
    price: "19.50", starts_on: "08-04-2017", user_id: 2, vendor_id: 5},
  %{details: "Netflix 4K", ends_on: "25-10-2018", name: "Netflix 4k",
    price: "19.50", starts_on: "01-01-2017", user_id: 3, vendor_id: 5}          
]

Enum.each(contracts, fn(contract) -> Agreement.create_contract(contract) end)