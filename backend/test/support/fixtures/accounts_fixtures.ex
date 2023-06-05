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
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> BadgerDates.Accounts.create_message()

    message
  end
end
