defmodule HomePage.ImagesTest do
  use HomePage.DataCase

  alias HomePage.Images

  describe "photos" do
    alias HomePage.Images.Photo

    @valid_attrs %{image: "some image", name: "some name"}
    @update_attrs %{image: "some updated image", name: "some updated name"}
    @invalid_attrs %{image: nil, name: nil}

    def photo_fixture(attrs \\ %{}) do
      {:ok, photo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Images.create_photo()

      photo
    end

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Images.list_photos() == [photo]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Images.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid data creates a photo" do
      assert {:ok, %Photo{} = photo} = Images.create_photo(@valid_attrs)
      assert photo.image == "some image"
      assert photo.name == "some name"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      assert {:ok, photo} = Images.update_photo(photo, @update_attrs)
      assert %Photo{} = photo
      assert photo.image == "some updated image"
      assert photo.name == "some updated name"
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_photo(photo, @invalid_attrs)
      assert photo == Images.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Images.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Images.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Images.change_photo(photo)
    end
  end
end
