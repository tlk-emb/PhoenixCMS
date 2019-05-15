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

end
