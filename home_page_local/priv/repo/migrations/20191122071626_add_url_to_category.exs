defmodule HomePage.Repo.Migrations.AddUrlToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :url, :string, null: false
    end
    create unique_index(:categories, [:url])
  end
end
