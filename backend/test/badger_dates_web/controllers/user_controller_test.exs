defmodule BadgerDatesWeb.UserControllerTest do
  use BadgerDatesWeb.ConnCase

  import BadgerDates.AccountsFixtures

  alias BadgerDates.Accounts.User

  @create_attrs %{
    age: 42,
    location: "some location",
    major: "some major",
    name: "some name",
    email: "addr@wisc.edu",
    image_url: "https://url.com"
  }
  @update_attrs %{
    age: 43,
    location: "some updated location",
    major: "some updated major",
    name: "some updated name"
  }
  @invalid_attrs %{age: nil, location: nil, major: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    setup do
      create_user(%User{name: "Todd"})
    end

    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @create_attrs)
      assert %{"id" => user_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, user_id))

      assert %{
               "id" => ^user_id,
               "age" => 42,
               "location" => "some location",
               "major" => "some major",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "age" => 43,
               "location" => "some updated location",
               "major" => "some updated major",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
