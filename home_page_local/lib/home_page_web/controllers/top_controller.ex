defmodule HomePageWeb.TopController do
  use HomePageWeb, :controller
  alias HomePage.Contents
  alias HomePage.Contents.ComponentItem

  def index(conn, _params) do
    component_items =
      Contents.list_component_items()
    render(conn, "index.html", component_items: component_items)
  end

  def preview(conn, _params) do
    component_items =
      Contents.list_component_items()
    render(conn, "preview.html", component_items: component_items)
  end

end
