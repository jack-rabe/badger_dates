defmodule BadgerDates.Repo.Migrations.AddImageUrl do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE users ADD COLUMN image_url text")
  end
end
