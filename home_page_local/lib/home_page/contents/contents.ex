defmodule HomePage.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset

  alias HomePage.Repo

  alias HomePage.Contents.ComponentItem

  alias HomePage.Accounts.User

  alias HomePage.Pages.Category

  @doc """
  Returns the list of component_items.

  ## Examples

      iex> list_component_items()
      [%ComponentItem{}, ...]

  """
  def list_component_items do
      ComponentItem
      |> order_by(asc: :position, desc: :inserted_at)
      |> Repo.all()
      |> Repo.preload(:users)
  end


  @doc """
  Gets a single component_item.

  Raises `Ecto.NoResultsError` if the Component item does not exist.

  ## Examples

      iex> get_component_item!(123)
      %ComponentItem{}

      iex> get_component_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_component_item!(id) do
    ComponentItem
    |> Repo.get!(id)
    |> Repo.preload(:users)
  end

  def get_last_inserted() do
    ComponentItem
    |> last(:inserted_at)
    |> Repo.one()
  end

  def get_last_updated() do
    ComponentItem
    |> last(:updated_at)
    |> Repo.one()
  end

  def get_last_position() do
    ComponentItem
    |> last(:position)
    |> Repo.one()
  end

  def position_asc_updated_desc() do
    ComponentItem
    |> order_by(asc: :position, desc: :updated_at)
  end
  def position_asc_inserted_desc() do
    ComponentItem
    |> order_by(asc: :position, desc: :inserted_at)
  end

  def get_category_matched(items, category) do
    query = from item in items,
      where: item.category == ^category
    query
    |> Repo.all()
  end

  def build_component_item() do
    %ComponentItem{
      title: "undifined",
      tab: 1,
      size: 1
    }
  end

  @doc """
  Creates a component_item.

  ## Examples

      iex> create_component_item(%{field: value})
      {:ok, %ComponentItem{}}

      iex> create_component_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_component_item(%User{} = user, %{"category" => category} = attrs) do
    # 一つ目のitemは強制的にpositionを1にする
    items =
      ComponentItem
      |> get_category_matched(category)
    attrs = %{attrs | "description" => ""}
    case items do
      i when i == [] ->
        %ComponentItem{}
        |> ComponentItem.changeset(attrs)
        |> Ecto.Changeset.put_change(:user_id, user.id)
        |> Ecto.Changeset.put_change(:position, 1)
        |> Repo.insert()
      _ ->
        %ComponentItem{}
        |> ComponentItem.changeset(attrs)
        |> Ecto.Changeset.put_change(:user_id, user.id)
        |> Repo.insert()
    end
  end

  def create_blank_items(%User{} = user, %{"category" => category}) do
    component_items =
      position_asc_inserted_desc()
      |> get_category_matched(category)
    component_items
    |> blank_check(component_items)
    |> blank_size_set(0, user) #リストでの操作に加えDBにも挿入
  end

  @doc """
  Updates a component_item.

  ## Examples

      iex> update_component_item(component_item, %{field: new_value})
      {:ok, %ComponentItem{}}

      iex> update_component_item(component_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_component_item(%ComponentItem{id: id} = component_item, %{} = attrs) do
    #items = ComponentItem
    #        |> Repo.all()
    attrs = %{attrs | "description" => "#{id}.txt"}

    component_item
      |> ComponentItem.changeset(attrs)
      |> Repo.update()
  end
 # positionを引き上げる処理
  def position_up(%{} = attrs) do
    #各カテゴリー毎にpositionを振り分ける
    Category
    |> Repo.all()
    |> Enum.map(fn(x) ->
      items =
        position_asc_updated_desc()
        |> get_category_matched(x.title)
        |> Enum.reject(fn(x) -> x.position < String.to_integer(attrs["position"]) end)
      #　update後のpositionが重複しているとき
      case items do
        [_ | tail] ->
          tail
          |> Enum.map(fn(x) ->
                      x
                      |> ComponentItem.changeset(%{"position" => x.position + 1})
                      |> Repo.update()
                    end)
        _ -> nil
      end
    end)
  end
 # positionを引き下げる処理
  def position_down(items, category, count) do
    # count初期値0
    case count do
      # 先頭positionが1じゃないとき1まで引き下げる
      0 ->
        case items do
          [%{position: hp} | _] when hp > 1 ->
            items
            |> Enum.map(fn(x) ->
                        x
                        |> ComponentItem.changeset(%{"position" => x.position - (hp - 1)})
                        |> Repo.update()
                      end)
            position_asc_updated_desc()
            |> get_category_matched(category)
            |> position_down(category, 1)
          _ ->
            items
            |> position_down(category, 1)
        end

      # positionに隙間ができたとき引き下げる
      c when c > 0 ->
        case items do
          [%{position: hp} | [%{position: tp} | _] = tail] when hp + 1 < tp ->
            tail
            |> Enum.map(fn(x) ->
                        x
                        |> ComponentItem.changeset(%{"position" => x.position  - (tp - hp) + 1})
                        |> Repo.update()
                      end)
            position_asc_updated_desc()
            |> get_category_matched(category)
            |> position_down(category, 1)
          [head | tail] ->
              tail
              |> position_down(category, 1)
          _ ->
            nil
        end
    end
  end

  def position_up_after_create() do
    target =
      ComponentItem
      |> last(:inserted_at)
      |> Repo.one()
    items =
      position_asc_inserted_desc()
      |> get_category_matched(target.category)
      |> Enum.reject(fn(x) -> x.position < target.position end)
    target
    |> ComponentItem.changeset(%{"description" => "#{target.id}.txt"})
    |> Repo.update()
    case items do
      [%{position: hp} | [%{position: tp} | _] = tail] when hp == tp ->
        tail
        |> Enum.map(fn(x) ->
                    x
                    |> ComponentItem.changeset(%{"position" => x.position + 1})
                    |> Repo.update()
                  end)
      _ ->
        nil
    end
  end

# 各itemに何行目に表示するかを与える ただし、各行最初のitemにはそれを示すために負の数を付加する
  def line_set(items, size_sum, line) do
    #suze_sum:初期値0,line:初期値1
    case items do
      i when i == [] ->
        nil
      [%{position: hp, size: hs} = head | tail] ->
        case hp do
          1 ->
            head
            |> ComponentItem.changeset(%{"line" => -1})
            |> Repo.update()
            line_set(tail, hs, line)
          _ ->
            case hs do
              s when (size_sum + s) > 11 ->
                head
                |> ComponentItem.changeset(%{"line" => -(line + 1)})
                |> Repo.update()
                line_set(tail, hs, line + 1)
              _ ->
                head
                |> ComponentItem.changeset(%{"line" => line})
                |> Repo.update()
                line_set(tail, size_sum + hs, line)
              end
        end
    end
  end

  # categoryがeditで名前が変わった時、対応するアイテムのcategoryの名前も変える
  def renew_category(items, new_category) do
    items
    |> Enum.map(fn(x) ->
                x
                |> ComponentItem.changeset(%{"category" => new_category})
                |> Repo.update()
                end)
  end

  @doc """
  Deletes a ComponentItem.

  ## Examples

      iex> delete_component_item(component_item)
      {:ok, %ComponentItem{}}

      iex> delete_component_item(component_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_component_item(%ComponentItem{} = component_item) do
    Repo.delete(component_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking component_item changes.

  ## Examples

      iex> change_component_item(component_item)
      %Ecto.Changeset{source: %ComponentItem{}}

  """
  def change_component_item(%ComponentItem{} = component_item) do
    ComponentItem.changeset(component_item, %{})
  end


  # positionが飛んだところにblankを挿入
  defp blank_check(items, rest) do
    case rest do
      r when length(r) <= 1 ->
        items
      ##  atodekesu
      [%{position: hp} | [%{position: tp} | _] = tail]
      when hp == tp ->
        blank_check(items, tail)
      ##
      [%{position: hp} | [%{position: tp} | _] = tail]
      when hp + 1 != tp ->
        blank = %{
          position: hp + 1,
          blank: true
        }
        List.insert_at(items, hp, blank)
        |> blank_check([blank | tail])
      [_ | tail] ->
        blank_check(items, tail)
    end
  end

  # blankがrowを満たすようにサイズを調整し、更にDBにも挿入
  defp blank_size_set(items, size_sum, %User{} = user) do
    #size_sum:初期値0
    case items do
      i when i == [] ->
        []

      [%{blank: _, position: hp} | tail] ->
        blank =
          %{
            "title" => "blank",
            "description" => "blank",
            "position" => hp,
            "size" => 11 - size_sum
          }
        %ComponentItem{}
        |> ComponentItem.changeset(blank)
        |> Changeset.put_change(:user_id, user.id)
        |> Repo.insert()

        [blank | blank_size_set(tail, 0, user)]

      [%{size: hs} = head | tail] ->
        case hs do
          n when (size_sum + n) > 11 ->
            [head | blank_size_set(tail, hs, user)]

          _ ->
            [head | blank_size_set(tail, size_sum + hs, user)]
        end
    end
  end

end
