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

  @doc """
    returns a single User who has not been linked before
  """
  def get_potential_match(conn, %{"user_id" => user_id}) do
    link = Accounts.get_potential_match(user_id)

    if is_nil(link) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{data: "no matches"}))
    else
      render(conn, "show.json", user: link)
    end
  end

  @doc """
    returns all potential links for a given user (probably not needed)
  """
  def links(conn, %{"user_id" => user_id}) do
    conn = put_view(conn, BadgerDatesWeb.UserLinksView)
    links = Accounts.list_user_links(user_id)
    render(conn, "index.json", links: links)
  end

  def accept_match(conn, params) do
    handle_match(conn, params, "yes")
  end

  def decline_match(conn, params) do
    handle_match(conn, params, "no")
  end

  defp handle_match(conn, %{"user_id" => user_id, "other_id" => other_id}, answer) do
    link = Accounts.get_link!(user_id, other_id)

    user_atom =
      cond do
        link.user1 == user_id -> :user1_response
        true -> :user2_response
      end

    with {:ok, %UserLink{} = link} <- Accounts.update_link(link, %{user_atom => answer}) do
      conn = put_view(conn, BadgerDatesWeb.UserLinksView)
      render(conn, "show.json", link: link)
    end
  end
end
