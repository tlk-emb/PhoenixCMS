defmodule HomePageWeb.ComponentItemControllerTest do
  use HomePageWeb.ConnCase

  alias HomePage.Contents

  @create_attrs %{description: "some description", position: 42, size: 42, title: "some title"}
  @update_attrs %{description: "some updated description", position: 43, size: 43, title: "some updated title"}
  @invalid_attrs %{description: nil, position: nil, size: nil, title: nil}

  def fixture(:component_item) do
    {:ok, component_item} = Contents.create_component_item(@create_attrs)
    component_item
  end

  describe "index" do
    test "lists all component_items", %{conn: conn} do
      conn = get conn, component_item_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Component items"
    end
  end

  describe "new component_item" do
    test "renders form", %{conn: conn} do
      conn = get conn, component_item_path(conn, :new)
      assert html_response(conn, 200) =~ "New Component item"
    end
  end

  describe "create component_item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, component_item_path(conn, :create), component_item: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == component_item_path(conn, :show, id)

      conn = get conn, component_item_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Component item"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, component_item_path(conn, :create), component_item: @invalid_attrs
      assert html_response(conn, 200) =~ "New Component item"
    end
  end

  describe "edit component_item" do
    setup [:create_component_item]

    test "renders form for editing chosen component_item", %{conn: conn, component_item: component_item} do
      conn = get conn, component_item_path(conn, :edit, component_item)
      assert html_response(conn, 200) =~ "Edit Component item"
    end
  end

  describe "update component_item" do
    setup [:create_component_item]

    test "redirects when data is valid", %{conn: conn, component_item: component_item} do
      conn = put conn, component_item_path(conn, :update, component_item), component_item: @update_attrs
      assert redirected_to(conn) == component_item_path(conn, :show, component_item)

      conn = get conn, component_item_path(conn, :show, component_item)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, component_item: component_item} do
      conn = put conn, component_item_path(conn, :update, component_item), component_item: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Component item"
    end
  end

  describe "delete component_item" do
    setup [:create_component_item]

    test "deletes chosen component_item", %{conn: conn, component_item: component_item} do
      conn = delete conn, component_item_path(conn, :delete, component_item)
      assert redirected_to(conn) == component_item_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, component_item_path(conn, :show, component_item)
      end
    end
  end

  defp create_component_item(_) do
    component_item = fixture(:component_item)
    {:ok, component_item: component_item}
  end
end
