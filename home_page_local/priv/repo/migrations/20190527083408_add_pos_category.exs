defmodule HomePage.Repo.Migrations.AddPosCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :position, :integer, null: false
    end
  end
end
