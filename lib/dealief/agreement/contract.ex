defmodule Dealief.Agreement.Contract do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dealief.Agreement.Contract
  alias Dealief.Agreement.{Vendor, ContractDate}
  alias Dealief.Account.User

  @timestamps_opts [usec: false]
  schema "contracts" do
    field :details, :string
    field :ends_on, ContractDate
    field :name, :string
    field :price, :decimal
    field :starts_on, ContractDate
    belongs_to :user, User
    belongs_to :vendor, Vendor
    
    timestamps()
  end

  @doc false
  def changeset(%Contract{} = contract, attrs) do
    contract
    |> cast(attrs, [:name, :details, :starts_on, :ends_on, :price, :vendor_id, :user_id])
    |> validate_required([:name, :starts_on, :ends_on, :price, :vendor_id, :user_id], message: "should not be empty")
    |> compare_contract_dates
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:vendor_id)
  end

  defp compare_contract_dates(changeset) do
    ends_on = get_field(changeset, :ends_on)
    starts_on = get_field(changeset, :starts_on)
    if ends_on && starts_on && NaiveDateTime.compare(ends_on, starts_on) == :lt do
      add_error(changeset,:ends_on,"Ends on should be greater than Starts on",[validation: :compare_contract_dates])
    else
      changeset
    end
  end  
end
