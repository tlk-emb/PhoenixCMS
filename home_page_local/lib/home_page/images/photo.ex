defmodule HomePage.Images.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:name, :string, []}
  @derive {Phoenix.Param, key: :name}

  schema "photos" do
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:name, :image])
    |> validate_required([:name, :image])
  end
end
