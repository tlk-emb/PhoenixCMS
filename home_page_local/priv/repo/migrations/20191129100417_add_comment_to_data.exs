defmodule HomePage.Repo.Migrations.AddCommentToData do
  use Ecto.Migration

  def change do
    alter table(:datas) do
      add :comment, :string
    end
  end
end
