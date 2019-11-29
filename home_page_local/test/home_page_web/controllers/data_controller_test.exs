defmodule HomePageWeb.DataControllerTest do
  use HomePageWeb.ConnCase

  alias HomePage.TemporaryFiles

  @create_attrs %{name: "some name", path: "some path"}
  @update_attrs %{name: "some updated name", path: "some updated path"}
  @invalid_attrs %{name: nil, path: nil}

  def fixture(:data) do
    {:ok, data} = TemporaryFiles.create_data(@create_attrs)
    data
  end

  describe "index" do
    test "lists all datas", %{conn: conn} do
      conn = get conn, data_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Datas"
    end
  end

  describe "new data" do
    test "renders form", %{conn: conn} do
      conn = get conn, data_path(conn, :new)
      assert html_response(conn, 200) =~ "New Data"
    end
  end

  describe "create data" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, data_path(conn, :create), data: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == data_path(conn, :show, id)

      conn = get conn, data_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Data"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, data_path(conn, :create), data: @invalid_attrs
      assert html_response(conn, 200) =~ "New Data"
    end
  end

  describe "edit data" do
    setup [:create_data]

    test "renders form for editing chosen data", %{conn: conn, data: data} do
      conn = get conn, data_path(conn, :edit, data)
      assert html_response(conn, 200) =~ "Edit Data"
    end
  end

  describe "update data" do
    setup [:create_data]

    test "redirects when data is valid", %{conn: conn, data: data} do
      conn = put conn, data_path(conn, :update, data), data: @update_attrs
      assert redirected_to(conn) == data_path(conn, :show, data)

      conn = get conn, data_path(conn, :show, data)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, data: data} do
      conn = put conn, data_path(conn, :update, data), data: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Data"
    end
  end

  describe "delete data" do
    setup [:create_data]

    test "deletes chosen data", %{conn: conn, data: data} do
      conn = delete conn, data_path(conn, :delete, data)
      assert redirected_to(conn) == data_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, data_path(conn, :show, data)
      end
    end
  end

  defp create_data(_) do
    data = fixture(:data)
    {:ok, data: data}
  end
end
