defmodule BadgerDatesWeb.UserController do
  use BadgerDatesWeb, :controller

  alias BadgerDates.Accounts
  alias BadgerDates.Accounts.User

  action_fallback BadgerDatesWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    with {:ok, %User{} = new_user} <- Accounts.create_user(user_params) do
      Enum.each(Accounts.list_users(), fn %User{id: other_id} ->
        if new_user.id != other_id do
          Accounts.create_user_link(%{user1: new_user.id, user2: other_id})
        end
      end)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, new_user))
      |> render("show.json", user: new_user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def links(conn, %{"user_id" => user_id}) do
    links = Accounts.list_user_links(user_id)
    conn = put_view(conn, BadgerDatesWeb.UserLinksView)
    render(conn, "index.json", links: links)
  end
end
