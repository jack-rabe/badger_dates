defmodule BadgerDates.Repo.Migrations.AddEmailToUser do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE users ADD COLUMN email text")
  end
end
