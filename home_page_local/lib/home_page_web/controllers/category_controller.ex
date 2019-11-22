defmodule HomePageWeb.CategoryController do
  use HomePageWeb, :controller

  alias HomePage.Pages
  alias HomePage.Contents
  def index(conn, _params) do
    categories = Pages.get_pos_asc_ins_desc()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Pages.build_category()
                |> Pages.change_category()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Pages.create_category(category_params) do
      {:ok, category} ->
          conn
          |> redirect(to: category_path(conn, :solve_dupl_update))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"url" => url}) do
    # そのカテゴリに属するアイテムを表示
    category = Pages.get_category_title(url)
    component_items = Contents.position_asc_updated_desc()
                      |> Contents.get_category_matched(category)
    render(conn, "show.html", component_items: component_items)
  end

  def preview(conn, %{"url" => url}) do
    # そのカテゴリに属するアイテムを表示
    category = Pages.get_category_title(url)
    component_items = Contents.position_asc_updated_desc()
                      |> Contents.get_category_matched(category)
    render(conn, "preview.html", component_items: component_items)
  end

  def edit(conn, %{"id" => id}) do
    category = Pages.get_category!(id)
    changeset = Pages.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    pre_category = Pages.get_category!(id)
    case Pages.update_category(pre_category, category_params) do
      {:ok, category} ->
        Contents.position_asc_updated_desc()
        |> Contents.get_category_matched(pre_category.title)
        |> Contents.renew_category(category.title)
        Pages.get_pos_asc_upd_desc()
        |> solve_dupl(1)
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category_params, changeset: changeset)
    end
  end

  def solve_dupl_update(conn, _params) do
    Pages.get_pos_asc_ins_desc()
    |> solve_dupl(1)
    conn
    |> put_flash(:info, "Category created successfully.")
    |> redirect(to: category_path(conn, :index))
  end
  defp solve_dupl(categories, num) do
    case categories do
      [%{id: 1} | tl] ->
        solve_dupl(tl, num)
      [hd | tl] ->
        Pages.update_category(hd, %{"position" => num})
        solve_dupl(tl, num + 1)
      _ ->
        nil
    end
  end

  def solve_blank_update(conn, _params) do
    Pages.get_pos_asc_ins_desc()
    |> solve_dupl(1)
    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: component_item_path(conn, :after_category_delete_update))
  end

  def delete(conn, %{"id" => id}) do
    category = Pages.get_category!(id)
    {:ok, _category} = Pages.delete_category(category)

    conn
    |> redirect(to: category_path(conn, :solve_blank_update))
  end
end
