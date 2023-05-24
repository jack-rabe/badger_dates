defmodule BadgerDates.Repo.Migrations.CreateUserLinks do
  use Ecto.Migration

  def change do
    create table(:user_links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user1, :uuid
      add :user2, :uuid
      add :user1_response, :boolean, default: false, null: false
      add :user2_response, :boolean, default: false, null: false

      timestamps()
    end
  end
end
