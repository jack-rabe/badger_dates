defmodule BadgerDates.Accounts.UserLink do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_links" do
    field :user1, Ecto.UUID
    field :user1_response, :boolean, default: false
    field :user2, Ecto.UUID
    field :user2_response, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user_link, attrs) do
    user_link
    |> cast(attrs, [:user1, :user2, :user1_response, :user2_response])
    |> validate_required([:user1, :user2, :user1_response, :user2_response])
  end
end
