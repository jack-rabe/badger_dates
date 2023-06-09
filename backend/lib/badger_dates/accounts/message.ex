defmodule BadgerDates.Accounts.Message do
  alias BadgerDates.Accounts.{User, UserLink}
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    belongs_to :link, UserLink, type: Ecto.UUID
    belongs_to :user, User, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :link_id, :user_id, :inserted_at])
    |> validate_required([:content, :link_id, :user_id])
  end
end
