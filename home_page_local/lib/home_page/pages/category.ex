defmodule HomePage.Pages.Category do
  use Ecto.Schema
  import Ecto.Changeset


  schema "categories" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
