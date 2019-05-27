defmodule HomePageWeb.ComponentItemView do
  use HomePageWeb, :view
  alias HomePage.Accounts
  alias HomePage.Pages
  alias HomePage.Repo
  def current_user(conn) do
    Accounts.current_user(conn)
  end
  def categories() do
    Pages.list_categories()
  end
end
