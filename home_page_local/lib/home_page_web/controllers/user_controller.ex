defmodule HomePageWeb.UserController do
  use HomePageWeb, :controller
  alias HomePage.Accounts
  alias HomePage.Accounts.User
  alias HomePage.Accounts.Guardian
  alias HomePage.Accounts.AuthTokens
  alias Comeonin.Bcrypt

  # in[]内のメソッド実行前にis_authorized(defp)を実行するplug
  plug :is_authorized when action in [:edit, :email_edit, :password_edit, :update, :email_update, :password_update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  #def new(conn, _params) do
  #  changeset = Accounts.change_user(%User{})
  #  render(conn, "new.html", changeset: changeset)
  #end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "ユーザ登録ができました.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, _) do
    changeset = Accounts.change_user(conn.assigns.current_user)
    render(conn, "edit.html", user: conn.assigns.current_user, changeset: changeset)
  end


  def email_edit(conn, _) do
    changeset = Accounts.change_user(conn.assigns.current_user)
    render(conn, "email_edit.html", user: conn.assigns.current_user, changeset: changeset)
  end

  def password_edit(conn, _) do
    changeset = Accounts.change_user(conn.assigns.current_user)
    render(conn, "password_edit.html", user: conn.assigns.current_user, changeset: changeset)
  end

  def email_update(conn, %{"user" => %{"password" => password, "email" => email} = user_params}) do
    user = conn.assigns.current_user
    Accounts.authenticate_password(email, password, user)
    |> edit_reply_email(conn, user_params, user)
  end

  def password_update(conn, %{"user" => %{"pre_password" => pre_password, "password" => password, "re_password" => re_password} = user_params}) do
    user = conn.assigns.current_user
    case re_password do
      p when p == password ->
        #pre_passwordが認証を通ればpasswordで更新する
        Accounts.authenticate_pre_password(pre_password, user)
        |> edit_reply_password(conn, user_params, user)
      _ ->
        conn
        |> put_flash(:error, "変更後のパスワードが一致していません")
        |> redirect(to: user_path(conn, :password_edit, user))
    end
  end

  #メールアドレス変更時のパスワード認証の応答
  defp edit_reply_email({:error, error}, conn, _user_params, user) do
    conn
    |> put_flash(:error, error) #error:メッセージ
    |> redirect(to: user_path(conn, :email_edit, user))
  end
  defp edit_reply_email({:ok, user}, conn, user_params, _user) do
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "メールアドレスを変更しました.")
        |> redirect(to: user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "email_edit.html", user: conn.assigns.current_user, changeset: changeset)
    end
  end

  #パスワード変更時のパスワード認証の応答
  defp edit_reply_password({:error, error}, conn, _user_params, user) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: user_path(conn, :password_edit, user))
  end
  defp edit_reply_password({:ok, user}, conn, user_params, _user) do
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "パスワードを変更しました.")
        |> redirect(to: user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "password_edit.html", user: conn.assigns.current_user, changeset: changeset)
    end
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "ユーザ情報を更新しました.")
        |> redirect(to: user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end


  def delete(conn, _) do
    {:ok, _user} = Accounts.delete_user(conn.assigns.current_user)

    conn
    |> put_flash(:info, "ユーザを削除しました.")
    |> redirect(to: top_path(conn, :index))
  end

  #パスワード再発行において、アドレスが正しいか
  def reset_edit(conn, %{"token" => token}) do
    #tokenがDBにあるか
    case Guardian.decode_and_verify(token) do
      {:error, _} ->
        {:error, ""}
        |> reset_reply(conn)
      {:ok, claims} ->
        #tokenが有効か
        AuthTokens.on_verify(claims, token)
        |> reset_reply(conn, token)
    end
  end
  #新パスワード入力
  def reset_update(conn, %{"id" => id, "token" => token, "claims" => claims, "user" => %{"password" => password, "re_password" => re} = user_params}) do
    user = Accounts.get_user!(id)
    case password do
      p when p == re ->
        user_params = %{user_params | "password" => password}
        case Accounts.update_user(user, user_params) do
          {:ok, user} ->
            AuthTokens.on_revoke(claims, token)
            conn
            |> put_flash(:info, "パスワードを再設定しました")
            |> redirect(to: top_path(conn, :index))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "reset.html", user: user, changeset: changeset, token: token, claims: claims)
        end
      _ ->
        changeset = Accounts.change_user(user)
        conn
        |> put_flash(:error, "変更後のパスワードが一致していません")
        |> render("reset.html", user: user, changeset: changeset, token: token, claims: claims)
    end
  end

  defp reset_reply({:ok, claims}, conn, token) do
    user = Accounts.get_user!(claims["sub"])
    changeset = Accounts.change_user(user)
    render(conn, "reset.html", user: user, changeset: changeset, token: token, claims: claims)
  end
  defp reset_reply(_, conn, token) do
    conn
    |> put_flash(:error, "アドレスが無効です")
    |> redirect(to: top_path(conn, :index))
  end
  defp reset_reply(_, conn) do
    conn
    |> put_flash(:error, "アドレスが無効です")
    |> redirect(to: top_path(conn, :index))
  end

  # currentuserと編集対象のユーザーが一致するならconnにcurrent_user: current_userを挿入する
  defp is_authorized(conn, _) do
    current_user = Accounts.current_user(conn)
    if current_user.id == String.to_integer(conn.params["id"]) do
      assign(conn, :current_user, current_user) #connに格納
    else
      conn
      |> put_flash(:error, "その操作の権限がありません.")
      |> redirect(to: top_path(conn, :index, "normal"))
      |> halt()
    end
  end

end
