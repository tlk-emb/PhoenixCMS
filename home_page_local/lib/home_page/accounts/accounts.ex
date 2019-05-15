defmodule HomePage.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias HomePage.Repo

  alias HomePage.Accounts.User

  alias Comeonin.Bcrypt

  alias HomePage.Accounts.Guardian


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:component_items)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:component_items)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user
    |> User.changeset(%{})
  end

  #emailとpassword両方の認証
  def authenticate_user(email, plain_text_password) do
    query = from u in User, where: u.email == ^email
    Repo.one(query)
    |> Repo.preload(:component_items)
    |> check_password(plain_text_password)
  end
  # passwordのみの認証(email変更に使用)
  def authenticate_password(email, plain_text_password, current_user) do
    case Bcrypt.checkpw(plain_text_password, current_user.password) do
      true ->
        {:ok, current_user}
      false -> {:error, "パスワードが正しくありません"}
    end
  end
  # pre_passwordのみの認証（password変更に使用）
  def authenticate_pre_password(plain_text_pre_password, current_user) do
    case Bcrypt.checkpw(plain_text_pre_password, current_user.password) do
      true ->
        {:ok, current_user}
      false -> {:error, "パスワードが正しくありません"}
    end
  end

  #emailのみの認証(パスワード再発行に使用)
  def authenticate_email(email) do
    query = from u in User, where: u.email == ^email
    case Repo.one(query) do
      nil ->
        {:error, "そのメールアドレスは登録されていません"}
      user ->
        {:ok, user}
    end
  end

  defp check_password(nil, _), do: {:error, "メールアドレスかパスワードが不正です"}
  defp check_password(user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "メールアドレスかパスワードが不正です"}
    end
  end

  defp check_password_email(nil, _), do: {:error, "そのメールアドレスは登録されていません"}
  defp check_password_email(user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "そのメールアドレスは登録されていません"}
    end
  end


  def current_user(conn) do
    if Guardian.Plug.current_resource(conn) != nil do
      Guardian.Plug.current_resource(conn)
    else
      %{id: -1} #ログインユーザがいない時、id=-1
    end
  end

end
