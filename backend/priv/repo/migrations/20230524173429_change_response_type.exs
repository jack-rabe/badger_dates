defmodule BadgerDates.Repo.Migrations.ChangeResponseType do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE user_links ALTER COLUMN user1_response TYPE text")
    execute("ALTER TABLE user_links ALTER COLUMN user2_response TYPE text")
  end
end
