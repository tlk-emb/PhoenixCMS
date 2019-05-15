defmodule HomePage.Repo.Migrations.AddCategoryToItems do
  use Ecto.Migration

  def change do
    alter table(:component_items) do
      add :category, :string
    end
  end
end
