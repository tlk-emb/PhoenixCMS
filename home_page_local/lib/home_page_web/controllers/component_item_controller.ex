defmodule HomePageWeb.ComponentItemController do
  require IEx
  use HomePageWeb, :controller
  import Ecto.Query, warn: false
  import Phoenix.HTML #raw

  alias HomePage.Contents
  alias HomePage.Pages
  alias HomePage.Pages.Category
  alias HomePage.Repo
  alias Ecto.Changeset
  #alias HomePage.Contents.ComponentItem

  def index(conn, _params) do
    component_items = Contents.list_component_items()
    render(conn, "index.html", component_items: component_items)
  end

  def new(conn, %{"url" => url}) do
    component_item = Contents.build_component_item()
    category = url
              |> Pages.get_category_title()

    # positionのデフォルト値
    case Contents.get_last_position_in_category(category) do
      nil ->
        component_item = %{component_item | position: 1, category: category}
        changeset = Contents.change_component_item(component_item)
        render(conn, "new.html", component_item: component_item, changeset: changeset)
      p ->
        component_item = %{component_item | position: p.position + 1, category: category}
        changeset = Contents.change_component_item(component_item)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"component_item" => component_item_params}) do
    path = System.get_env("HOME_PAGE_CONTENTS")#"/Users/admin/projects/local/home_page_local/priv/static/contents/"
    case Contents.create_component_item(Guardian.Plug.current_resource(conn), component_item_params) do #現在のユーザ情報と、createするitem情報
      {:ok, _} ->
        created = Contents.get_last_inserted()
        Contents.create_blank_items(Guardian.Plug.current_resource(conn), component_item_params)
        case component_item_params["tab"] do #タブの数によってdescriptionの処理がかわる
          "1" ->
            File.write(path <> "#{created.id}.txt",
                          component_item_params["description"])

          _ ->
            description = tab_encord(component_item_params, created.id)
            File.write(path <> "#{created.id}.txt", description)
        end
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
    path = System.get_env("HOME_PAGE_CONTENTS")
    component_item = Contents.get_component_item!(id)
    case File.read(path <> "#{component_item.id}.txt") do
      {:ok, description} ->
        component_item = %{component_item | description: raw(description_rewrite(description, id))}
        changeset = Contents.change_component_item(component_item)
        render(conn, "edit.html", component_item: component_item, changeset: changeset)
      {:error, _} ->
        component_item = %{component_item | description: ""}
        changeset = Contents.change_component_item(component_item)
        render(conn, "edit.html", component_item: component_item, changeset: changeset)
    end
  end

  # descriptionを、タブを持つなら"<タブタイトルの列挙(id="tt数字")>+<タブコンテンツの列挙(id="tc数字")>"にする
  # no-displayクラスのdivタグのテキストエリアに入る(DBからhtmlに渡す)
  defp description_rewrite(description, id) do
    #splittedのサイズが1なら、タブコンテンツを持たない
    splitted = description
                |>String.split(~s{<ul class="nav nav-tabs">})
    case length(splitted) do
       1 ->
        description
       _ ->
        #タブコンテンツを分ける
        splitted_more = splitted
                        |> tl
                        |> hd
                        |> String.split(~s{data-toggle="tab">})#長さ-1でタブの数になる
        splitted_more
        |> tab_title_collect(1, length(splitted_more) - 1, id)
    end
  end
  defp tab_title_collect(splitted_more, tab_id, tab_number, item_id) do
    case length(splitted_more) do
      #再起の初回のみhdがゴミ
      lll when lll == tab_number + 1 ->
        splitted_more
        |> tl
        |> tab_title_collect(tab_id, tab_number, item_id)
      # 長さが2以上ならまだ2つ以上タブタイトルがある
      ll when ll > 1 ->
        ~s{<div id="#{item_id}_tt#{Integer.to_string(tab_id)}">}
        <>
        (splitted_more
        |> hd
        |> String.split("</a>")
        |> hd) #これがタブタイトル
        <> "</div>"
        <> tab_title_collect((tl splitted_more), tab_id + 1, tab_number, item_id)
      # 長さが1のとき、タブタイトルはあとひとつなので処理後、コンテンツの取得に移行
      l when l == 1 ->
        s = splitted_more
            |> hd
            |> String.split(~s{<div class="tab-content">})
            |> tl
            |> hd  # <div id = "..." class="tab-pane active">以降の文字列
            |> String.split(["</div>", "<div id =", ~s{class="tab-pane">}, ~s{class="tab-pane active">}])
            |> Enum.reject(fn(x) -> x == "" end)
            |> Enum.reject(fn(x) -> x == " " end)
            |> Enum.reject(fn(x) -> x == "　" end)
            |> Enum.reject(fn(x) -> x == "\n" end)
            # ["タブid","タブコンテンツ","タブid","タブコンテンツ",...,]
        ~s{<div id="#{item_id}_tt#{Integer.to_string(tab_id)}">}
        <>
        (splitted_more
        |> hd
        |> String.split("</a>")
        |> hd) #これがタブタイトル
        <> "</div>"
        <> tab_content_collect(s, 1, item_id)
    end
  end
  defp tab_content_collect(splitted_more, tab_id, item_id) do
    case length(splitted_more) do
      l when l > 1 ->
        ~s{<div id="#{item_id}_tc#{Integer.to_string(tab_id)}">}
        <>
        (splitted_more
        |> tl
        |> hd #タブ一つ分のdescription
        |> String.split("                          ")# 何故かこれだけの空白が最初についてくるので除く
        |> tl
        |> hd)
        <> "</div>"
        <> tab_content_collect((tl tl splitted_more), tab_id + 1, item_id)
      _ ->
        ""
    end
  end

  def update(conn, %{"id" => id, "component_item" => component_item_params}) do
    path = System.get_env("HOME_PAGE_CONTENTS")
    component_item = Contents.get_component_item!(id)
    category = component_item_params["category"]
              |> Pages.get_category_url
    pre_category = component_item.category
    case Contents.update_component_item(component_item, component_item_params) do
      {:ok, _component_item} ->
        case component_item_params["tab"] do #タブの数によってdescriptionの処理がかわる
          "1" ->
            File.write(path <> "#{id}.txt",
                          component_item_params["description"])
          _ ->
            description = tab_encord(component_item_params, id)
            File.write(path <> "#{id}.txt", description)
        end
        Contents.position_up(component_item_params)
        #position_downは再帰関数なので初期リストを呼び出し側で与える
        changed = [category, pre_category]
        changed
        |> Enum.map(fn(x) ->
                    Contents.position_asc_updated_desc()
                    |> Contents.get_category_matched(x)
                    |> Contents.position_down(x, 0)
                    end)
        changed
        |> Enum.map(fn(x) ->
                    Contents.position_asc_updated_desc()
                    |> Contents.get_category_matched(x)
                    |> Contents.line_set(0, 1)
                    end)
        conn
        |> put_flash(:info, "[#{component_item.title}] を更新しました.")
        |> redirect(to: category_path(conn, :show, category))
      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = changeset
                    |> Changeset.put_change(:description, component_item_params["description"])
        render(conn, "edit.html", component_item: component_item, changeset: changeset)
    end
  end

# descriptionの内容から正しいhtmlコードに変換する
# htmlからDB(txt)に渡す
  defp tab_encord(params, id) do
    ~s{<ul class="nav nav-tabs">}
    <> (params["tab"]
        |> String.to_integer()
        |> list_create()#タブの数だけ要素数があるリスト
        |> Enum.map(fn(x) ->
                      case x do
                        1 ->
                          ~s{<li class="nav-item">
                            <a href="#{id}_tab#{x}" class="nav-link active" data-toggle="tab">#{params["tab#{x}_title"]}</a>
                          </li>}
                        _ ->
                        ~s{<li class="nav-item">
                          <a href="#{id}_tab#{x}" class="nav-link" data-toggle="tab">#{params["tab#{x}_title"]}</a>
                        </li>}
                      end
                    end)
        |> Enum.join(""))
    <> "</ul>"
    <> ~s{<div class="tab-content">}
    <> (params["tab"]
        |> String.to_integer()
        |> list_create()#タブの数だけ要素数があるリスト
        |> Enum.map(fn(x) ->
                      case x do
                        1 ->
                          ~s{<div id="#{id}_tab#{x}" class="tab-pane active">
                          #{params["tab#{x}_text"]}
                          </div>}
                        _ ->
                          ~s{<div id="#{id}_tab#{x}" class="tab-pane">
                          #{params["tab#{x}_text"]}
                          </div>}
                      end
                    end)
        |> Enum.join(""))
    <> "</div>"
  end
# [1,2,...,num]のリストを生成する
  defp list_create(num) do
    [1,2,3,4,5,6,7,8,9,10]
    |> Enum.reject(fn(x) -> x > num end)
  end

# createやdeleteのあとに行うupdate
  def after_create_update(conn, _params) do
    Contents.position_up_after_create()#ここでdescriptionはテキストファイルの名前に変換
    category = Contents.get_last_updated().category
    url = Pages.get_category_url(category)
    Contents.position_asc_updated_desc()
    |> Contents.get_category_matched(category)
    |> Contents.position_down(category, 0)
    Contents.position_asc_updated_desc()
    |> Contents.get_category_matched(category)
    |> Contents.line_set(0,1)
    conn
    |> redirect(to: category_path(conn, :show, url))
  end
  def after_delete_update(conn, %{"url" => url}) do#削除したカテゴリのコンテンツを再整列
    category = url
              |> Pages.get_category_title()#urlからtitle取得
    Contents.position_asc_updated_desc#position調整
    |> Contents.get_category_matched(category)
    |> Contents.position_down(category, 0)
    Contents.position_asc_updated_desc#line調整
    |> Contents.get_category_matched(category)
    |> Contents.line_set(0,1)
    conn
    |> redirect(to: category_path(conn, :show, url))
  end

  # 全てのコンテンツに対してcategoryが消えていたらundifinedにする処理をかける
  def after_category_delete_update(conn, _params) do
    Contents.list_component_items
    |> Enum.map(fn(x) ->
                  case Pages.get_category_id(x.category) do
                    nil -> Contents.update_component_item(x, %{"category" => "undifined", "description" => ""})#
                    _ ->
                  end
                end)
    conn
    |> redirect(to: category_path(conn, :index))
  end

  def delete(conn, %{"id" => id, "url" => url}) do
    path = System.get_env("HOME_PAGE_CONTENTS")
    component_item = Contents.get_component_item!(id)
    {:ok, _component_item} = Contents.delete_component_item(component_item)
    File.rm(path <> "#{id}.txt")

    conn
    |> put_flash(:info, "[#{component_item.title}] を削除しました.")
    |> redirect(to: component_item_path(conn, :after_delete_update, url: url))
  end
end
