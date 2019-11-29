defmodule HomePage.TemporaryFilesTest do
  use HomePage.DataCase

  alias HomePage.TemporaryFiles

  describe "datas" do
    alias HomePage.TemporaryFiles.Data

    @valid_attrs %{name: "some name", path: "some path"}
    @update_attrs %{name: "some updated name", path: "some updated path"}
    @invalid_attrs %{name: nil, path: nil}

    def data_fixture(attrs \\ %{}) do
      {:ok, data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TemporaryFiles.create_data()

      data
    end

    test "list_datas/0 returns all datas" do
      data = data_fixture()
      assert TemporaryFiles.list_datas() == [data]
    end

    test "get_data!/1 returns the data with given id" do
      data = data_fixture()
      assert TemporaryFiles.get_data!(data.id) == data
    end

    test "create_data/1 with valid data creates a data" do
      assert {:ok, %Data{} = data} = TemporaryFiles.create_data(@valid_attrs)
      assert data.name == "some name"
      assert data.path == "some path"
    end

    test "create_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TemporaryFiles.create_data(@invalid_attrs)
    end

    test "update_data/2 with valid data updates the data" do
      data = data_fixture()
      assert {:ok, data} = TemporaryFiles.update_data(data, @update_attrs)
      assert %Data{} = data
      assert data.name == "some updated name"
      assert data.path == "some updated path"
    end

    test "update_data/2 with invalid data returns error changeset" do
      data = data_fixture()
      assert {:error, %Ecto.Changeset{}} = TemporaryFiles.update_data(data, @invalid_attrs)
      assert data == TemporaryFiles.get_data!(data.id)
    end

    test "delete_data/1 deletes the data" do
      data = data_fixture()
      assert {:ok, %Data{}} = TemporaryFiles.delete_data(data)
      assert_raise Ecto.NoResultsError, fn -> TemporaryFiles.get_data!(data.id) end
    end

    test "change_data/1 returns a data changeset" do
      data = data_fixture()
      assert %Ecto.Changeset{} = TemporaryFiles.change_data(data)
    end
  end
end
