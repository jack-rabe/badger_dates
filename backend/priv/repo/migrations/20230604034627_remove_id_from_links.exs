defmodule BadgerDates.Repo.Migrations.RemoveIdFromLinks do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE user_links drop COLUMN id")
  end
end
