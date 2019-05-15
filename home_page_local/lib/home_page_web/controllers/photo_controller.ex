defmodule HomePageWeb.PhotoController do
  use HomePageWeb, :controller

  alias HomePage.Images
  alias HomePage.Images.Photo

  def index(conn, _params) do
    photos = Images.list_photos()
    render(conn, "index.html", photos: photos)
  end

  def new(conn, _params) do
    changeset = Images.change_photo(%Photo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"photo" => photo_params}) do
    try do
      case Images.create_photo(photo_params) do
        {:ok, photo} ->
          path = "/Users/admin/projects/home_page/priv/static" <> photo.image
          File.cp(photo_params["image"].path, path)
          conn
          |> put_flash(:info, "Photo created successfully.")
          |> redirect(to: photo_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    rescue
      e in Ecto.ConstraintError ->
        conn
        |> put_flash(:error, "その名前の画像は既にあります.")
        |> redirect(to: photo_path(conn, :new))
      e in FunctionClauseError ->
        conn
        |> put_flash(:error, "画像を選択してください.")
        |> redirect(to: photo_path(conn, :new))
      e in RuntimeError ->
        conn
        |> put_flash(:error, "画像を選択してください.")
        |> redirect(to: photo_path(conn, :new))
    end
  end

  def show(conn, %{"id" => name}) do
    photo = Images.get_photo!(name)
    render(conn, "show.html", photo: photo)
  end

  def edit(conn, %{"name" => name}) do
    photo = Images.get_photo!(name)
    changeset = Images.change_photo(photo)
    render(conn, "edit.html", photo: photo, changeset: changeset)
  end

  def update(conn, %{"name" => name, "photo" => photo_params}) do
    photo = Images.get_photo!(name)

    case Images.update_photo(photo, photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo updated successfully.")
        |> redirect(to: photo_path(conn, :show, photo))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", photo: photo, changeset: changeset)
    end
  end

  #ルータで明示的にパラメータ名を指定しなければ渡るパラメータではname(主キー)はidフィールドの中に入る
  def delete(conn, %{"id" => name}) do
    photo = Images.get_photo!(name)
    {:ok, _photo} = Images.delete_photo(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: photo_path(conn, :index))
  end
end
