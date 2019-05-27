defmodule HomePage.Repo.Migrations.AddItemsCategory do
  use Ecto.Migration

  def change do
    alter table(:component_items) do
      add :category, :string, null: false
    end
  end
end
