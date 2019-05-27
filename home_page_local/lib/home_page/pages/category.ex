defmodule HomePage.Pages.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}

  schema "categories" do
    field :title, :string
    field :position, :integer

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :position])
    |> validate_required([:title, :position])
    |> unique_constraint(:title)
    |> validate_number(:position, greater_than: 0)
  end
end
