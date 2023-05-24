defmodule BadgerDates.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BadgerDates.Repo
  alias BadgerDates.Accounts.User
  alias BadgerDates.Accounts.UserLink

  @doc """
  Creates links to all other existing users
  """
  def create_user_link(attrs \\ %{}) do
    %UserLink{}
    |> UserLink.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Returns the list of user links for a given user that the user has not already responded to 
  """
  def list_user_links(user_id) do
    from(ul in UserLink,
      where:
        (ul.user1 == ^user_id and ul.user1_response == "") or
          (ul.user2 == ^user_id and ul.user2_response == "")
    )
    |> Repo.all()
  end

  def get_link!(link_id), do: Repo.get!(UserLink, link_id)

  def get_link!(user1_id, user2_id) do
    from(ul in UserLink,
      where:
        (ul.user1 == ^user1_id and ul.user2 == ^user2_id) or
          (ul.user1 == ^user2_id and ul.user2 == ^user1_id)
    )
    |> Repo.one!()
  end

  def update_link(%UserLink{} = link, attrs) do
    link
    |> UserLink.changeset(attrs)
    |> Repo.update()
  end

  # TODO remove duplicate query code
  def get_potential_match(user_id) do
    %UserLink{user1: user1, user2: user2} =
      from(ul in UserLink,
        where:
          (ul.user1 == ^user_id and ul.user1_response == "") or
            (ul.user2 == ^user_id and ul.user2_response == "")
      )
      |> Repo.one!()

    if user_id == user2 do
      get_user!(user1)
    else
      get_user!(user2)
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
