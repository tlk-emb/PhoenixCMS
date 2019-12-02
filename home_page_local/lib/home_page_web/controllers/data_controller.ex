defmodule HomePageWeb.DataController do
  use HomePageWeb, :controller

  alias HomePage.TemporaryFiles
  alias HomePage.TemporaryFiles.Data

  def index(conn, _params) do
    datas = TemporaryFiles.list_datas()
    render(conn, "index.html", datas: datas)
  end

  def new(conn, _params) do
    changeset = TemporaryFiles.change_data(%Data{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"data" => file_params}) do
    try do
      TemporaryFiles.create_data(file_params)
          |> Enum.map(fn f ->
            case f do
              {:ok, data} ->
                save_path = System.get_env("HOME_PAGE_STATIC") <> "temporary/#{data.name}" #static/temporaryへの絶対パス(保存先)
                File.cp(data.path, save_path)
              {:error, _} ->
                raise("error")
              end
            end)
      conn
      |> put_flash(:info, "File uploaded successfully.")
      |> redirect(to: data_path(conn, :index))
    rescue
      #formから渡るデータが仮想フィールドのみのため、submit時にunique制約を判定できないのでこちらでガードする
      e in Ecto.ConstraintError ->
        conn
        |> put_flash(:error, "This filename has been already uploaded.")
        |> redirect(to: data_path(conn, :new))
      e in Ecto.CaseClauseError ->
        conn
        |> put_flash(:error, "This filename has been already uploaded.")
        |> redirect(to: data_path(conn, :new))
      e in FunctionClauseError ->
        conn
        |> put_flash(:error, "Select Files.")
        |> redirect(to: data_path(conn, :new))
      e in ActionClauseError ->
        conn
        |> put_flash(:error, "Select Files.")
        |> redirect(to: data_path(conn, :new))
      e in RuntimeError ->
        conn
        |> put_flash(:error, "This filename has been already uploaded.")
        |> redirect(to: data_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    data = TemporaryFiles.get_data!(id)
    render(conn, "show.html", datas: data)
  end

  def edit(conn, %{"id" => id}) do
    data = TemporaryFiles.get_data!(id)
    changeset = TemporaryFiles.change_data(data)
    render(conn, "edit.html", datas: data, changeset: changeset)
  end

  def update(conn, %{"id" => id, "data" => data_params}) do
    data = TemporaryFiles.get_data!(id)

    case TemporaryFiles.update_data(data, data_params) do
      {:ok, data} ->
        conn
        |> put_flash(:info, "File updated successfully.")
        |> redirect(to: data_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", datas: data, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    data = TemporaryFiles.get_data!(id)

    case TemporaryFiles.delete_data(data) do
      {:ok, _params} ->
        path = System.get_env("HOME_PAGE_STATIC") <> "temporary/#{data.name}"
        File.rm(path)
        conn
        |> put_flash(:info, "File deleted successfully.")
        |> redirect(to: data_path(conn, :index))
      _ -> 0
    end
  end

  def download(conn, %{"id" => id}) do
    name = TemporaryFiles.get_data!(id).name
    path = Application.app_dir(:home_page, "/priv/static/temporary/#{name}")
    kind = {:file, path}
    send_download(conn, kind)#lemoteディレクトリからfile downloadする関数
    conn
    |> redirect(to: data_path(conn, :index))
  end
end
