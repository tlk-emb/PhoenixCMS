defmodule HomePage.Repo.Migrations.AddLineToComponentItems do
  use Ecto.Migration

  def change do
    alter table(:component_items) do
      add :line, :integer
    end
  end
end
