defmodule ChatApi.ChatApiTest do
  use ChatApi.DataCase

  alias ChatApi.ChatApi

  describe "users" do
    alias ChatApi.ChatApi.User

    @valid_attrs %{email: "some email", username: "some username"}
    @update_attrs %{email: "some updated email", username: "some updated username"}
    @invalid_attrs %{email: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ChatApi.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert ChatApi.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert ChatApi.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = ChatApi.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ChatApi.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = ChatApi.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = ChatApi.update_user(user, @invalid_attrs)
      assert user == ChatApi.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = ChatApi.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> ChatApi.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = ChatApi.change_user(user)
    end
  end

  describe "rooms" do
    alias ChatApi.ChatApi.Room

    @valid_attrs %{name: "some name", topic: "some topic"}
    @update_attrs %{name: "some updated name", topic: "some updated topic"}
    @invalid_attrs %{name: nil, topic: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ChatApi.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert ChatApi.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert ChatApi.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = ChatApi.create_room(@valid_attrs)
      assert room.name == "some name"
      assert room.topic == "some topic"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ChatApi.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, room} = ChatApi.update_room(room, @update_attrs)
      assert %Room{} = room
      assert room.name == "some updated name"
      assert room.topic == "some updated topic"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = ChatApi.update_room(room, @invalid_attrs)
      assert room == ChatApi.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = ChatApi.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> ChatApi.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = ChatApi.change_room(room)
    end
  end
end
