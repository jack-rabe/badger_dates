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
        name: "some name"
      })
      |> BadgerDates.Accounts.create_user()

    user
  end
end
