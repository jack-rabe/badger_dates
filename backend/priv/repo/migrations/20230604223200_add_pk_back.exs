defmodule BadgerDates.Repo.Migrations.AddPkBack do
  use Ecto.Migration

  def change do
    alter table(:user_links) do
      add :id, :binary_id, primary_key: true
    end
  end
end
