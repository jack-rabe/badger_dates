defmodule BadgerDates.AccountsTest do
  use BadgerDates.DataCase

  alias BadgerDates.Accounts
  alias BadgerDates.Accounts.{User, UserLink}

  describe "users" do
    import BadgerDates.AccountsFixtures

    @invalid_attrs %{age: nil, location: nil, major: nil, name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        age: 42,
        location: "some location",
        major: "some major",
        name: "some name",
        email: "addr@wisc.edu",
        image_url: "https://url.com"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.age == 42
      assert user.location == "some location"
      assert user.major == "some major"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        age: 43,
        location: "some updated location",
        major: "some updated major",
        name: "some updated name"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.age == 43
      assert user.location == "some updated location"
      assert user.major == "some updated major"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  describe "messages" do
    alias BadgerDates.Accounts.Message

    import BadgerDates.AccountsFixtures

    @invalid_attrs %{content: nil}

    test "create_message/1 with valid data creates a message" do
      # TODO refactor this duplicate code
      %User{id: user_id} = user_fixture()
      %User{id: other_user_id} = user_fixture()
      %UserLink{id: link_id} = link_fixture(user_id, other_user_id)
      valid_attrs = %{user_id: user_id, content: "some content", link_id: link_id}

      assert {:ok, %Message{} = message} = Accounts.create_message(valid_attrs)
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_message(@invalid_attrs)
    end

    test "delete_message/1 deletes the message" do
      %User{id: user_id} = user_fixture()
      %User{id: other_user_id} = user_fixture()
      %UserLink{id: link_id} = link_fixture(user_id, other_user_id)
      message = message_fixture(%{user_id: user_id, link_id: link_id})

      assert {:ok, %Message{}} = Accounts.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_message!(message.id) end
    end
  end
end
