defmodule BadgerDatesWeb.MessageControllerTest do
  use BadgerDatesWeb.ConnCase

  import BadgerDates.AccountsFixtures

  alias BadgerDates.Accounts.Message

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all messages", %{conn: conn} do
      conn = get(conn, Routes.message_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
