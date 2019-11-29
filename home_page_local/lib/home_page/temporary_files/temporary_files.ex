defmodule HomePage.TemporaryFiles do
  @moduledoc """
  The TemporaryFiles context.
  """

  import Ecto.Query, warn: false
  alias HomePage.Repo

  alias HomePage.TemporaryFiles
  alias HomePage.TemporaryFiles.Data

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_datas do
    Repo.all(Data)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_data!(id), do: Repo.get!(Data, id)

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_data(%{"file_list" => file_list,
                    "size_list" => size_list, "comment" => comment} = attrs) do

    size_list
    |> String.split(",")
    |> merge_size_to_list(file_list)
    |> Enum.map(fn f -> #fはPlug.Upload構造体でfilenameフィールドとpathフィールドがある
                %Data{}
                |> Data.changeset(%{"name" => f.filename,
                  "path" => f.path, "size" => f.size, "comment" => comment})
                |> Repo.insert()
              end)
  end
  defp merge_size_to_list([], []) do
    []
  end
  defp merge_size_to_list(size_list, file_list) do #sizelistからfilelistにsizeフィールドを足す
    size = size_list
          |> hd
    file = file_list
          |> hd
          |> Map.from_struct
          |> Map.merge(%{size: size})
    [file | merge_size_to_list(tl(size_list), tl(file_list))]
  end
  defp merge_size_to_list(_,_) do
    {:error, 0}
  end
  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_data(%Data{} = data, attrs) do
    data
    |> Data.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a File.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_data(%Data{} = data) do
    Repo.delete(data)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{source: %File{}}

  """
  def change_data(%Data{} = data) do
    Data.changeset(data, %{})
  end
end
