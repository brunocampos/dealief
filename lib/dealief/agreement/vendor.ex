defmodule Dealief.Agreement.Vendor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dealief.Agreement.Vendor
  alias Dealief.Agreement.Contract


  schema "vendors" do
    field :category, :string
    field :name, :string
    has_many :contracts, Contract

    timestamps()
  end

  @doc false
  def changeset(%Vendor{} = vendor, attrs) do
    vendor
    |> cast(attrs, [:name, :category])
    |> validate_required([:name, :category])
  end
end
