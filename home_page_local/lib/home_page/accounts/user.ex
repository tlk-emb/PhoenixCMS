defmodule HomePage.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias HomePage.Contents.ComponentItem
  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :pre_password, :string, virtual: true
    field :re_password, :string, virtual: true

    has_many :component_items, ComponentItem
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
    |> validate_length(:password, min: 6)
    |> validate_length(:pre_password, min: 6)
    |> validate_length(:re_password, min: 6)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
  defp put_pass_hash(changeset), do: changeset

end
