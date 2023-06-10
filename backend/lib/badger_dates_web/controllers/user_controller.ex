defmodule BadgerDatesWeb.UserController do
  use BadgerDatesWeb, :controller

  alias BadgerDates.Accounts.{User, UserLink}
  alias BadgerDates.Accounts

  action_fallback BadgerDatesWeb.FallbackController

  def create(conn, user_params) do
    # TODO - additional email validation (like uniqueness), maybe even sending them one
    with {:ok, %User{} = new_user} <- Accounts.create_user(user_params) do
      Task.async(fn -> Accounts.create_user_links(new_user) end)

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

  def get_confirmed_matches(conn, %{"user_id" => user_id}) do
    links = Accounts.list_confirmed_matches(user_id)
    conn = put_view(conn, BadgerDatesWeb.UserLinksView)

    matches =
      Enum.map(links, fn link ->
        user =
          if user_id == link.user1 do
            Accounts.get_user!(link.user2) |> Map.put(:link_id, link.id)
          else
            Accounts.get_user!(link.user1)
          end

        user |> Map.put(:link_id, link.id)
      end)

    render(conn, "with_users.json", links: matches)
  end

  @doc """
    returns a single User who has not been linked before
  """
  def get_potential_match(conn, %{"user_id" => user_id}) do
    case Accounts.get_potential_match(user_id) do
      nil ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{data: "no matches"}))

      match ->
        render(conn, "show.json", user: match)
    end
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
