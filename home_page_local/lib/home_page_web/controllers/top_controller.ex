defmodule HomePageWeb.TopController do
  use HomePageWeb, :controller
  alias HomePage.Contents
  alias HomePage.Contents.ComponentItem
  alias HomePage.Pages

  def index(conn, _params) do
    query = Pages.get_category!(2).url
    conn
    |> redirect(to: category_path(conn, :show, query))
  end

end
