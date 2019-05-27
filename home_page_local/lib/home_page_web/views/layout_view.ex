defmodule HomePageWeb.LayoutView do
  use HomePageWeb, :view
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
  #最後にcomponent_itemsテーブルが更新された時間を返す
  def last_updated() do
    item = Contents.get_last_updated()
    [year, month, date_pre] =
      item.updated_at
      |> Timex.to_datetime
      |> DateTime.to_string
      |> String.split("-")
    [date, rest] =
      date_pre
      |> String.split(" ")
    %{year: year, month: month, date: date}
  end
end
