defmodule HomePage.Repo.Migrations.AddThumbnailToComponentItems do
  use Ecto.Migration

  def change do
    alter table(:component_items) do
      add :thumbnail, :string
    end
  end
end
