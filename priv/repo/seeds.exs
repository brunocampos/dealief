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