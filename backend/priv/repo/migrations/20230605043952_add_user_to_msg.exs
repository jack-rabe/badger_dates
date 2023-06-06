defmodule BadgerDates.Repo.Migrations.AddUserToMsg do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :user_id, references(:users, type: :binary_id)
    end
  end
end
