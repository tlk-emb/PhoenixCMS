defmodule HomePage.Pages do
  @moduledoc """
  The Pages context.
  """

  import Ecto.Query, warn: false
  alias HomePage.Repo

  alias HomePage.Pages.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)
  def get_category_by_pos(position) do
    Category
    |> Repo.get_by(position: position)
  end

  def build_category() do
    p = Category
        |> last(:position)
        |> Repo.one()
    %Category{
      position: p.position + 1
    }
  end

  #position順に並べ、重複してるものは最後に更新/作成したものが先に来る
  def get_pos_asc_ins_desc() do
    Category
    |> order_by(asc: :position, desc: :inserted_at)
    |> Repo.all()
  end
  def get_pos_asc_upd_desc() do
    Category
    |> order_by(asc: :position, desc: :updated_at)
    |> Repo.all()
  end

  def get_category_id(category) do
    c = Category
        |> Repo.get_by(title: category)
    case c do
      nil -> nil
      n -> n.id
    end
  end

  def get_category_title(idorurl) when is_integer(idorurl) do#id -> title
    c = Repo.get!(Category, idorurl)
    case c do
      nil -> nil
      n -> n.title
    end
  end
  def get_category_title(idorurl) when is_binary(idorurl) do#url -> title
    c = Repo.get_by(Category, url: idorurl)
    case c do
      nil -> nil
      u -> u.title
    end
  end
  def get_category_url(title) do#title->url
    c = Repo.get_by(Category, title: title)
    case c do
      nil -> nil
      t -> t.url
    end
  end
  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
