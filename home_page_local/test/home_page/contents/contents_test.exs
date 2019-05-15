defmodule HomePage.ContentsTest do
  use HomePage.DataCase

  alias HomePage.Contents

  describe "component_item" do
    alias HomePage.Contents.ComponentItem

    @valid_attrs %{description: "some description", position: 42, size: 42, title: "some title"}
    @update_attrs %{description: "some updated description", position: 43, size: 43, title: "some updated title"}
    @invalid_attrs %{description: nil, position: nil, size: nil, title: nil}

    def component_item_fixture(attrs \\ %{}) do
      {:ok, component_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_component_item()

      component_item
    end

    test "list_component_item/0 returns all component_item" do
      component_item = component_item_fixture()
      assert Contents.list_component_item() == [component_item]
    end

    test "get_component_item!/1 returns the component_item with given id" do
      component_item = component_item_fixture()
      assert Contents.get_component_item!(component_item.id) == component_item
    end

    test "create_component_item/1 with valid data creates a component_item" do
      assert {:ok, %ComponentItem{} = component_item} = Contents.create_component_item(@valid_attrs)
      assert component_item.description == "some description"
      assert component_item.position == 42
      assert component_item.size == 42
      assert component_item.title == "some title"
    end

    test "create_component_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_component_item(@invalid_attrs)
    end

    test "update_component_item/2 with valid data updates the component_item" do
      component_item = component_item_fixture()
      assert {:ok, component_item} = Contents.update_component_item(component_item, @update_attrs)
      assert %ComponentItem{} = component_item
      assert component_item.description == "some updated description"
      assert component_item.position == 43
      assert component_item.size == 43
      assert component_item.title == "some updated title"
    end

    test "update_component_item/2 with invalid data returns error changeset" do
      component_item = component_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_component_item(component_item, @invalid_attrs)
      assert component_item == Contents.get_component_item!(component_item.id)
    end

    test "delete_component_item/1 deletes the component_item" do
      component_item = component_item_fixture()
      assert {:ok, %ComponentItem{}} = Contents.delete_component_item(component_item)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_component_item!(component_item.id) end
    end

    test "change_component_item/1 returns a component_item changeset" do
      component_item = component_item_fixture()
      assert %Ecto.Changeset{} = Contents.change_component_item(component_item)
    end
  end

  describe "component_items" do
    alias HomePage.Contents.ComponentItem

    @valid_attrs %{description: "some description", position: 42, size: 42, title: "some title"}
    @update_attrs %{description: "some updated description", position: 43, size: 43, title: "some updated title"}
    @invalid_attrs %{description: nil, position: nil, size: nil, title: nil}

    def component_item_fixture(attrs \\ %{}) do
      {:ok, component_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_component_item()

      component_item
    end

    test "list_component_items/0 returns all component_items" do
      component_item = component_item_fixture()
      assert Contents.list_component_items() == [component_item]
    end

    test "get_component_item!/1 returns the component_item with given id" do
      component_item = component_item_fixture()
      assert Contents.get_component_item!(component_item.id) == component_item
    end

    test "create_component_item/1 with valid data creates a component_item" do
      assert {:ok, %ComponentItem{} = component_item} = Contents.create_component_item(@valid_attrs)
      assert component_item.description == "some description"
      assert component_item.position == 42
      assert component_item.size == 42
      assert component_item.title == "some title"
    end

    test "create_component_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_component_item(@invalid_attrs)
    end

    test "update_component_item/2 with valid data updates the component_item" do
      component_item = component_item_fixture()
      assert {:ok, component_item} = Contents.update_component_item(component_item, @update_attrs)
      assert %ComponentItem{} = component_item
      assert component_item.description == "some updated description"
      assert component_item.position == 43
      assert component_item.size == 43
      assert component_item.title == "some updated title"
    end

    test "update_component_item/2 with invalid data returns error changeset" do
      component_item = component_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_component_item(component_item, @invalid_attrs)
      assert component_item == Contents.get_component_item!(component_item.id)
    end

    test "delete_component_item/1 deletes the component_item" do
      component_item = component_item_fixture()
      assert {:ok, %ComponentItem{}} = Contents.delete_component_item(component_item)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_component_item!(component_item.id) end
    end

    test "change_component_item/1 returns a component_item changeset" do
      component_item = component_item_fixture()
      assert %Ecto.Changeset{} = Contents.change_component_item(component_item)
    end
  end
end
