defmodule HomePage.Contents.ComponentItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias HomePage.Accounts.User

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}

  schema "component_items" do
    field :description, :string
    field :title, :string
    field :position, :integer
    field :size, :integer
    field :line, :integer #何行目か
    field :lock, :boolean
    field :thumbnail, :string
    field :category, :string
    field :tab, :integer

    field :tab1_title, :string, virtual: true
    field :tab1_text, :string, virtual: true
    field :tab2_title, :string, virtual: true
    field :tab2_text, :string, virtual: true
    field :tab3_title, :string, virtual: true
    field :tab3_text, :string, virtual: true
    field :tab4_title, :string, virtual: true
    field :tab4_text, :string, virtual: true
    field :tab5_title, :string, virtual: true
    field :tab5_text, :string, virtual: true
    field :tab6_title, :string, virtual: true
    field :tab6_text, :string, virtual: true
    field :tab7_title, :string, virtual: true
    field :tab7_text, :string, virtual: true
    field :tab8_title, :string, virtual: true
    field :tab8_text, :string, virtual: true
    field :tab9_title, :string, virtual: true
    field :tab9_text, :string, virtual: true
    field :tab10_title, :string, virtual: true
    field :tab10_text, :string, virtual: true


    belongs_to :users, User, foreign_key: :user_id
    timestamps()
  end

  @doc false
  def changeset(component_item, attrs) do
    component_item
    |> cast(attrs, [:title, :position, :description, :size, :line, :lock, :thumbnail, :user_id, :tab])
    |> validate_required([:title, :position, :size])
    |> validate_number(:position, greater_than: 0)
    |> validate_number(:size, greater_than: 0, less_than: 12)
    |> validate_number(:tab, greater_than: 0, less_than: 11)
  end
end
