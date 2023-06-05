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
        content: "some content",
        link_id: "fea7f3d8-1f9d-4b72-b7c8-42afc2a42ab3"
      })
      |> BadgerDates.Accounts.create_message()

    message
  end
end
