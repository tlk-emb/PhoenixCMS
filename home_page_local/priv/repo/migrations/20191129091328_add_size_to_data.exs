defmodule HomePage.Repo.Migrations.AddSizeToData do
  use Ecto.Migration

  def change do
    alter table(:datas) do
      add :size, :string
    end
  end
end
