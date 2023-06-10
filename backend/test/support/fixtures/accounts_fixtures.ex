defmodule BadgerDates.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BadgerDates.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        age: 42,
        location: "some location",
        major: "some major",
        name: "some name",
        email: "addr@wisc.edu",
        image_url: "https://url.com"
      })
      |> BadgerDates.Accounts.create_user()

    user
  end

  @doc """
  Generate a link.
  """
  def link_fixture(user1_id, user2_id) do
    {:ok, link} =
      %{user1: user1_id, user2: user2_id}
      |> BadgerDates.Accounts.create_user_link()

    link
  end

  @doc """
  Generate a message.
  """
  def message_fixture(%{user_id: user_id, link_id: link_id}) do
    {:ok, message} =
      %{
        user_id: user_id,
        content: "some content",
        link_id: link_id
      }
      |> BadgerDates.Accounts.create_message()

    message
  end
end
