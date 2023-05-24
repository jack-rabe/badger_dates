defmodule BadgerDatesWeb.UserController do
  use BadgerDatesWeb, :controller

  alias BadgerDates.Accounts.UserLink
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

  # routes for UserLinks

  def get_potential_match(conn, %{"user_id" => user_id}) do
    link = Accounts.get_potential_match(user_id)
    render(conn, "show.json", user: link)
  end

  def links(conn, %{"user_id" => user_id}) do
    conn = put_view(conn, BadgerDatesWeb.UserLinksView)
    links = Accounts.list_user_links(user_id)
    render(conn, "index.json", links: links)
  end

  def update_link(conn, %{"link_id" => id, "link" => link_params}) do
    conn = put_view(conn, BadgerDatesWeb.UserLinksView)

    {:ok, updated_link} = Jason.decode(link_params)
    link = Accounts.get_link!(id)

    with {:ok, %UserLink{} = link} <- Accounts.update_link(link, updated_link) do
      render(conn, "show.json", link: link)
    end
  end
end