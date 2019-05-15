defmodule HomePage.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos, primary_key: false) do
      add :name, :string, primary_key: true
      add :image, :string, null: false

      timestamps()
    end

  end
end
