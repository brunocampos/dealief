defmodule Dealief.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dealief.Account.User
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  
  schema "users" do
    field :email, :string
    field :full_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :password])
    |> validate_required([:email, :full_name, :password], message: "should not be empty")
    |> validate_format(:email, ~r/@/, message: "is invalid")
    |> validate_length(:password, min: 6, max: 30)
    |> unique_constraint(:email)
    |> set_hashed_password
  end

  defp set_hashed_password(changeset) do
    case changeset.valid? do
      true ->
        changes = changeset.changes
        put_change(changeset, :password_hash, hashpwsalt(changes.password))
      _ ->
        changeset  
    end
  end  
end
