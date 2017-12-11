defmodule Dealief.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dealief.Account.User


  schema "users" do
    field :email, :string
    field :full_name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :password_hash])
    |> validate_required([:full_name, :email, :password_hash])
  end
end
