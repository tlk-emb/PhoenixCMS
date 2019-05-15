defmodule HomePage.Contents.ComponentItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias HomePage.Accounts.User

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}

  schema "component_items" do
    field(:description, :string)
    field(:title, :string)
    field(:position, :integer)
    field(:size, :integer)
    field(:line, :integer) #何行目か
    field(:lock, :boolean)
    field(:thumbnail, :string)
    field(:category, :string)
    field(:tab, :integer)

    belongs_to(:users, User, foreign_key: :user_id)
    timestamps()
  end

  @doc false
  def changeset(component_item, attrs) do
    component_item
    |> cast(attrs, [:title, :position, :description, :size, :line, :lock, :thumbnail, :user_id])
    |> validate_required([:title, :position, :size])
    |> validate_number(:position, greater_than: 0)
    |> validate_number(:size, greater_than: 0, less_than: 12)
    |> validate_number(:tab, greater_than: -1, less_than: 10)
  end
end
