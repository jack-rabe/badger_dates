defmodule BadgerDates.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BadgerDates.Repo
  alias BadgerDates.Accounts.{User, UserLink}

  @doc """
  Creates links to all other existing users
  """
  def create_user_link(attrs \\ %{}) do
    %UserLink{}
    |> UserLink.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of user links for a given user that both people have said yes to
  """
  def list_confirmed_matches(user_id) do
    from(ul in UserLink,
      where:
        (ul.user1 == ^user_id or ul.user2 == ^user_id) and ul.user1_response == "yes" and
          ul.user2_response == "yes"
    )
    |> Repo.all()
  end

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
    matching_links =
      from(ul in UserLink,
        where:
          (ul.user1 == ^user_id and ul.user1_response == "") or
            (ul.user2 == ^user_id and ul.user2_response == "")
      )
      |> Repo.all()

    if Enum.empty?(matching_links) do
      nil
    else
      [first_link | _tl] = matching_links
      valid_match = Repo.preload(first_link, :user_one) |> Repo.preload(:user_two)

      if user_id == valid_match.user2 do
        valid_match.user_one
      else
        valid_match.user_two
      end
    end
  end

  # creates links between a new user and all other users
  def create_user_links(%User{id: new_id}) do
    Enum.each(list_users(), fn %User{id: other_id} ->
      if new_id != other_id do
        create_user_link(%{user1: new_id, user2: other_id})
      end
    end)
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

  alias BadgerDates.Accounts.Message

  @doc """
  Returns the list of messages associated with a
  """
  def list_messages(link_id) do
    from(msg in Message,
      where: msg.link_id == ^link_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
