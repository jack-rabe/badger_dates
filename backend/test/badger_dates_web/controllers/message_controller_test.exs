defmodule BadgerDatesWeb.MessageControllerTest do
  use BadgerDatesWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all messages", %{conn: conn} do
      test_id = Ecto.UUID.autogenerate()
      conn = get(conn, "#{Routes.message_path(conn, :index)}?user_link=#{test_id}")
      assert json_response(conn, 200)["data"] == []
    end
  end
end
