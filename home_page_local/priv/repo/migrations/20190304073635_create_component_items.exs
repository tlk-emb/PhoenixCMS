defmodule HomePage.Repo.Migrations.CreateComponentItems do
  use Ecto.Migration

  def change do
    create table(:component_items) do
      add :title, :string, null: false
      add :description, :string
      add :position, :integer, null: false
      add :size, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:component_items, [:user_id])
  end
end
