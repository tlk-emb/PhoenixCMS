defmodule HomePage.Repo.Migrations.AddTabToItems do
  use Ecto.Migration

  def change do
    alter table(:component_items) do
      add :tab, :integer
    end
  end
end
