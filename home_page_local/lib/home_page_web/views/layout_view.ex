defmodule HomePageWeb.LayoutView do
  use HomePageWeb, :view
  use Timex
  alias HomePage.Accounts.Guardian
  alias HomePage.Contents
  alias HomePage.Pages
  def current_user(conn, temp) do
    case temp do
      "preview.html" ->
        nil
      _ ->
        Guardian.Plug.current_resource(conn)
    end
  end
  def component_items(category) do
    Contents.position_asc_updated_desc()
    |> Contents.get_category_matched(category)
  end
  def top_category_title() do
    Pages.get_category!(2).title
  end
  def current_category(conn) do #現在のカテゴリ名を取得
    category = conn.request_path
          |> URI.decode()
          |> String.split("index/")
    case length(category) do
        1 -> "undifined"
        _ ->
          category
          |> tl
          |> hd
          |> Pages.get_category_title
    end
  end
  def next_category(position) do
    case Pages.get_category_by_pos(position + 1) do
      nil ->
        nil
      c -> c.title
    end
  end
  def under_category(position) do
    case Pages.get_category_by_pos(position + 4) do
      nil ->
        nil
      c -> c.title
    end
  end

  def category_list() do
    #1列に4個ヘッダに並ぶので、4で割った余りの数が最下段(0なら最下段は4つ)
    #最下段以外のカテゴリには下にボーダーを引くので区別する
    reverse_list = Pages.get_pos_asc_ins_desc()
                  |> tl()
                  |> Enum.reverse()
    last_row_num = reverse_list
                  |> length()
                  |> rem(4)
    case last_row_num do
      # 最下段のカテゴリだけpositionを負の数にする
      0 -> add_last_row(reverse_list, 4)
            |> Enum.reverse()
      _ -> add_last_row(reverse_list, last_row_num)
            |> Enum.reverse()
    end
  end
  defp add_last_row(reverse_list, last_row_num) do
    case last_row_num do
      n when n > 0 ->
        hd = reverse_list
              |> hd()
        [Map.put(hd, :position, - hd.position)
            | add_last_row(tl(reverse_list), last_row_num - 1)]
      _ ->
        reverse_list
    end
  end
  def saved_date() do
    path = "/Users/admin/projects/local/home_page_local/priv/static/saved"
    case File.ls(path) do
      {:ok, list} ->
        list
        |> tl()
      {:error, _raeson} ->
        ["", "", ""]
    end
  end
  #最後にcomponent_itemsテーブルが更新された時間を返す
  def last_updated() do
    item = Contents.get_last_updated()
    timezone = Timezone.get("Asia/Tokyo", Timex.now)
    [year, month, date_pre] =
      item.updated_at
      |> Timezone.convert(timezone)
      |> DateTime.to_string
      |> String.split("-")
    [date, rest, _, _] =
      date_pre
      |> String.split(" ")
    %{year: year, month: month, date: date}
  end
end
