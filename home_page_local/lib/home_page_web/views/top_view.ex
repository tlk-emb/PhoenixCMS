defmodule HomePageWeb.TopView do
  use HomePageWeb, :view
  alias HomePage.Accounts

  def current_user(conn) do
    Accounts.current_user(conn)
  end

  # アイテムが何行目かを返す(%{"行数" => アイテムの数}というマップを返す)
  def how_line(items, line, map, list) do
    # lineの初期値1,mapの初期値%{},listの初期値[]
    case items do
      [%{line: hl} | tail] when abs(hl) == line ->
        how_line(tail, line, map, [hl | list])
      [%{line: hl} | tail] when abs(hl) > line ->
        how_line(tail, line + 1,
          Map.merge(map, %{"#{line}" => length(list)}), [hl])
      [] ->
        Map.merge(map, %{"#{line}" => length(list)})
    end
  end

  def parse_markdown(markdown) do
    Earmark.as_html!(markdown)
  end

  defp list_create(num) do
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    |> Enum.reject(fn(x) -> x > num end)
  end

end
