defmodule HomePageWeb.ComponentItemView do
  use HomePageWeb, :view
  alias HomePage.Accounts
  def current_user(conn) do
    Accounts.current_user(conn)
  end
end
