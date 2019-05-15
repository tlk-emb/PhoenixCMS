defmodule HomePage.Repo.Migrations.AddSecret do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :secret_key, :string
    end
  end
end
