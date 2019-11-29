defmodule HomePage.TemporaryFiles.Data do
  use Ecto.Schema
  import Ecto.Changeset


  schema "datas" do
    field :name, :string
    field :path, :string #sourceのパス
    field :size, :string
    field :comment, :string

    field :file_list, :string, virtual: true
    field :size_list, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(data, attrs) do
    data
    |> cast(attrs, [:name, :path, :size, :comment])
    |> validate_required([:name, :path])
    |> unique_constraint(:name)
  end
end
