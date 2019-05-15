defmodule HomePageWeb.PhotoControllerTest do
  use HomePageWeb.ConnCase

  alias HomePage.Images

  @create_attrs %{image: "some image", name: "some name"}
  @update_attrs %{image: "some updated image", name: "some updated name"}
  @invalid_attrs %{image: nil, name: nil}

  def fixture(:photo) do
    {:ok, photo} = Images.create_photo(@create_attrs)
    photo
  end

  describe "index" do
    test "lists all photos", %{conn: conn} do
      conn = get conn, photo_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Photos"
    end
  end

  describe "new photo" do
    test "renders form", %{conn: conn} do
      conn = get conn, photo_path(conn, :new)
      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "create photo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, photo_path(conn, :create), photo: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == photo_path(conn, :show, id)

      conn = get conn, photo_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Photo"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, photo_path(conn, :create), photo: @invalid_attrs
      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "edit photo" do
    setup [:create_photo]

    test "renders form for editing chosen photo", %{conn: conn, photo: photo} do
      conn = get conn, photo_path(conn, :edit, photo)
      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "update photo" do
    setup [:create_photo]

    test "redirects when data is valid", %{conn: conn, photo: photo} do
      conn = put conn, photo_path(conn, :update, photo), photo: @update_attrs
      assert redirected_to(conn) == photo_path(conn, :show, photo)

      conn = get conn, photo_path(conn, :show, photo)
      assert html_response(conn, 200) =~ "some updated image"
    end

    test "renders errors when data is invalid", %{conn: conn, photo: photo} do
      conn = put conn, photo_path(conn, :update, photo), photo: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "delete photo" do
    setup [:create_photo]

    test "deletes chosen photo", %{conn: conn, photo: photo} do
      conn = delete conn, photo_path(conn, :delete, photo)
      assert redirected_to(conn) == photo_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, photo_path(conn, :show, photo)
      end
    end
  end

  defp create_photo(_) do
    photo = fixture(:photo)
    {:ok, photo: photo}
  end
end
