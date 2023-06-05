defmodule BadgerDates.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :link_id, references(:user_links, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:messages, [:link_id])
  end
end
