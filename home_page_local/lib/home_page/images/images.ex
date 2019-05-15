defmodule HomePage.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias HomePage.Repo

  alias HomePage.Images.Photo

  @doc """
  Returns the list of photos.

  ## Examples

      iex> list_photos()
      [%Photo{}, ...]

  """
  def list_photos do
    Photo
    |> select([u], [:name, :image])
    |> Repo.all()
  end

  @doc """
  Gets a single photo.

  Raises `Ecto.NoResultsError` if the Photo does not exist.

  ## Examples

      iex> get_photo!(123)
      %Photo{}

      iex> get_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_photo!(name), do: Repo.get!(Photo, name)

  @doc """
  Creates a photo.

  ## Examples

      iex> create_photo(%{field: value})
      {:ok, %Photo{}}

      iex> create_photo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_photo(%{"name" => name, "image" => image} = attrs) do
    IO.inspect attrs
    extension = Path.extname(image.filename)#拡張子
      case name do
        "" ->
          path = "/images/uploaded/#{image.filename}"
          %Photo{}
          |> Photo.changeset(%{"name" => image.filename,"image" => path})
          |> Repo.insert()
        _ ->
          path = "/images/uploaded/#{name <> extension}"
          %Photo{}
          |> Photo.changeset(%{"name" => name <> extension,"image" => path})
          |> Repo.insert()
      end
  end

  @doc """
  Updates a photo.

  ## Examples

      iex> update_photo(photo, %{field: new_value})
      {:ok, %Photo{}}

      iex> update_photo(photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Photo.

  ## Examples

      iex> delete_photo(photo)
      {:ok, %Photo{}}

      iex> delete_photo(photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_photo(%Photo{} = photo) do
    Repo.delete(photo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking photo changes.

  ## Examples

      iex> change_photo(photo)
      %Ecto.Changeset{source: %Photo{}}

  """
  def change_photo(%Photo{} = photo) do
    Photo.changeset(photo, %{})
  end
end
