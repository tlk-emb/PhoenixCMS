defmodule HomePage.Pages.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}

  schema "categories" do
    field :title, :string
    field :position, :integer
    field :url, :string
    field :bcolor, :string
    field :ccolor, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :url, :position, :bcolor, :ccolor])
    |> validate_required([:title, :url, :position, :bcolor, :ccolor])
    |> unique_constraint(:title)
    |> unique_constraint(:url)
    |> validate_number(:position, greater_than: -1)
    |> validate_format(:bcolor, ~r/^[0-9a-f]{6}$/i)
    |> validate_format(:ccolor, ~r/^[0-9a-f]{6}$/i)
  end
end
