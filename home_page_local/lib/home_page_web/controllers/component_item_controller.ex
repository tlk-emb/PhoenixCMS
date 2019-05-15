defmodule HomePageWeb.ComponentItemController do
  use HomePageWeb, :controller
  import Ecto.Query, warn: false

  alias HomePage.Contents
  alias HomePage.Repo
  alias Ecto.Changeset
  #alias HomePage.Contents.ComponentItem

  def index(conn, _params) do
    component_items = Contents.list_component_items()
    render(conn, "index.html", component_items: component_items)
  end

  def new(conn, _params) do
    component_item = Contents.build_component_item()

    # positionのデフォルト値
    case Contents.get_last_position() do
      nil ->
        component_item = %{component_item | position: 1}
        changeset = Contents.change_component_item(component_item)
        render(conn, "new.html", component_item: component_item, changeset: changeset)
      p ->
        component_item = %{component_item | position: p.position + 1}
        changeset = Contents.change_component_item(component_item)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"component_item" => component_item_params}) do
    path = "/Users/admin/projects/local/home_page_local/priv/static/contents/"
    case Contents.create_component_item(Guardian.Plug.current_resource(conn), component_item_params) do #現在のユーザ情報と、createするitem情報
      {:ok, _component_item} ->
        Contents.create_blank_items(Guardian.Plug.current_resource(conn))
        created = Contents.get_last_inserted()
        File.write(path <> "#{created.id}.txt",
                      component_item_params["description"])
        conn
        |> put_flash(:info, "[#{component_item_params["title"]}] を作成しました.")
        |> redirect(to: component_item_path(conn, :after_create_update))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    component_item = Contents.get_component_item!(id)
    render(conn, "show.html", component_item: component_item)
  end

  def edit(conn, %{"id" => id}) do
    path = "/Users/admin/projects/local/home_page_local/priv/static/contents/"
    component_item = Contents.get_component_item!(id)
    case File.read(path <> "#{component_item.id}.txt") do
      {:ok, description} ->
        component_item = %{component_item | description: description}
        changeset = Contents.change_component_item(component_item)
        render(conn, "edit.html", component_item: component_item, changeset: changeset)
      {:error, _} ->
    end
  end

  def update(conn, %{"id" => id, "component_item" => component_item_params}) do
    path = "/Users/admin/projects/local/home_page_local/priv/static/contents/"
    component_item = Contents.get_component_item!(id)
    case Contents.update_component_item(component_item, component_item_params) do
      {:ok, _component_item} ->
        File.write(path <> "#{id}.txt",
                      component_item_params["description"])
        Contents.position_up(component_item_params)
        Contents.list_component_items()
        |> Contents.position_down(0)
        Contents.list_component_items()
        |> Contents.line_set(0, 1)
        conn
        |> put_flash(:info, "[#{component_item.title}] を更新しました.")
        |> redirect(to: top_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = changeset
                    |> Changeset.put_change(:description, component_item_params["description"])
        render(conn, "edit.html", component_item: component_item, changeset: changeset)
    end
  end

# createやdeleteのあとに行うupdate
  def after_create_update(conn, _params) do
    Contents.position_up_after_create()
    Contents.list_component_items()
    |> Contents.line_set(0,1)
    conn
    |> redirect(to: top_path(conn, :index))
  end
  def after_delete_update(conn, _params) do
    items = Contents.list_component_items()
    Contents.position_down(items, 0)
    Contents.line_set(items, 0, 1)
    conn
    |> redirect(to: top_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    path = "/Users/admin/projects/local/home_page_local/priv/static/contents/"
    component_item = Contents.get_component_item!(id)
    {:ok, _component_item} = Contents.delete_component_item(component_item)
    File.rm(path <> "#{id}.txt")

    conn
    |> put_flash(:info, "[#{component_item.title}] を削除しました.")
    |> redirect(to: component_item_path(conn, :after_delete_update))
  end
end
