defmodule BadgerDates.Accounts.UserLink do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerDates.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "user_links" do
    belongs_to :user_one, User, foreign_key: :user1, type: Ecto.UUID
    belongs_to :user_two, User, foreign_key: :user2, type: Ecto.UUID
    field :user1_response, :string, default: ""
    field :user2_response, :string, default: ""

    timestamps()
  end

  @doc false
  def changeset(user_link, attrs) do
    user_link
    |> cast(attrs, [:user1, :user2, :user1_response, :user2_response])
    |> validate_required([:user1, :user2])
  end
end
