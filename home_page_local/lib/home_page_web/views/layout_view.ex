defmodule HomePageWeb.LayoutView do
  use HomePageWeb, :view
  alias HomePage.Accounts.Guardian
  alias HomePage.Contents
  def current_user(conn, temp) do
    case temp do
      "preview.html" ->
        nil
      _ ->
        Guardian.Plug.current_resource(conn)
    end
  end
  def component_items() do
    Contents.list_component_items()
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
