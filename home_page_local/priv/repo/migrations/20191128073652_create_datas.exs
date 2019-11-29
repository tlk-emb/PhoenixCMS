defmodule HomePage.Repo.Migrations.CreateDatas do
  use Ecto.Migration

  def change do
    create table(:datas) do
      add :name, :string, null: false
      add :path, :string, null: false

      timestamps()
    end
    create unique_index(:datas, [:name])
  end
end
