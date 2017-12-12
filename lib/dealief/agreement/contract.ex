defmodule Dealief.Agreement.Contract do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dealief.Agreement.Contract


  schema "contracts" do
    field :details, :string
    field :ends_on, :naive_datetime
    field :name, :string
    field :price, :decimal
    field :starts_on, :naive_datetime
    field :vendor_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Contract{} = contract, attrs) do
    contract
    |> cast(attrs, [:name, :details, :starts_on, :ends_on, :price])
    |> validate_required([:name, :details, :starts_on, :ends_on, :price])
  end
end
