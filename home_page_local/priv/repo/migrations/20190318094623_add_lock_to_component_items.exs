defmodule HomePage.Repo.Migrations.AddLockToComponentItems do
  use Ecto.Migration

  def change do
    alter table(:component_items) do
      add :lock, :boolean, default: false, null: false
    end
  end
end
