defmodule HomePage.Repo.Migrations.AddColorToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :bcolor, :string
      add :ccolor, :string
    end
  end
end
