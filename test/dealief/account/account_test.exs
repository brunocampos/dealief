defmodule Dealief.AccountTest do
  use Dealief.DataCase

  alias Dealief.Account

  describe "users" do
    alias Dealief.Account.User

    @valid_attrs %{email: "john@example.com", full_name: "John", password: "password"}
    @update_attrs %{email: "john_smith@example.com", full_name: "John Smith", password: "updated_password"}
    @invalid_attrs %{email: nil, full_name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
      |> Map.replace(:password, nil)      
    end

    test "list_users/0 returns all users" do
      user = user_fixture()

      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()

      assert Account.get_user!(user.id) == user
    end

    test "get_user_by_email/1 return the user with given email" do
      user = user_fixture()

      assert Account.get_user_by_email(user.email) == user
    end

    test "login_user/1 with valid data returns a user" do
      user = user_fixture()

      assert {:ok, ^user} = Account.login_user(%{"email" => user.email, "password" => @valid_attrs.password})
    end

    test "login_user/1 with valid email but invalid password returns a error" do
      user = user_fixture()

      assert {:error, "Invalid login"} = Account.login_user(%{"email" => user.email, "password" => "some other password"})
    end    

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert user.full_name == @valid_attrs.full_name
      assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == @update_attrs.email
      assert user.full_name == @update_attrs.full_name
      assert Comeonin.Bcrypt.checkpw(@update_attrs.password, user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()

      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
