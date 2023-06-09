defmodule BadgerDates.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :age, :integer
    field :location, :string
    field :major, :string
    field :name, :string
    field :email, :string
    field :image_url, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :age, :location, :major, :image_url])
    |> validate_required([:name, :email, :age, :location, :major, :image_url])
    |> validate_format(:email, ~r/.+@wisc.edu/)
  end
end
