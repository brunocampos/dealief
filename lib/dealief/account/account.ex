defmodule Dealief.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Dealief.Repo

  alias Dealief.Account.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def login_user(%{"email" => email, "password" => password}) do
    user = get_user_by_email(email)
    if user && Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Invalid login"}
    end
  end
 

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
