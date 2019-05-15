defmodule HomePage.Repo.Migrations.RemoveSecretToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :secret_key
    end
  end
end
