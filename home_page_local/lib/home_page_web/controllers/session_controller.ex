defmodule HomePageWeb.SessionController do
  use HomePageWeb, :controller
  alias HomePage.Accounts
  alias HomePage.Accounts.User
  alias HomePage.Accounts.Guardian
  alias HomePage.Accounts.AuthTokens
  alias HomePage.Email
  alias HomePage.Mailer
  alias Comeonin.Bcrypt

  require Logger

  import Ecto.Query, warn: false
  alias HomePage.Repo

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end

  #パスワード再発行ページ
  def forget(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "forget.html", changeset: changeset)
  end
  #メール送信
  def send(conn, %{"user" => %{"email" => email}} = user_params) do
    case Accounts.authenticate_email(email) do
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: session_path(conn, :new))
      {:ok, user} ->
        {:ok, access_token, access_claims, refresh_token, _refresh_claims} = create_token(user)
        Email.reset_password(access_token, email, user.name)
        |> Mailer.deliver_now()
        render(conn, "send.html", user_id: user.id, email: user.email)
    end
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: session_path(conn, :new))
  end
  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end
  #ランダム文字列生成
  #defp secret_rand() do
  #  length = 32
  #  :crypto.strong_rand_bytes(length)
  #  |> Base.encode64
  #  |> binary_part(0, length)
  #end

  defp create_token(user) do
      {:ok, access_token, access_claims} = Guardian.encode_and_sign(user, %{}, [token_type: "access", ttl: {60, :minutes}])
      {:ok, refresh_token, refresh_claims} = Guardian.encode_and_sign(user, %{access_token: access_token}, [token_type: "refresh", ttl: {4, :weeks}])
      {:ok, _a_token} = AuthTokens.after_encode_and_sign(user, access_claims, access_token)
      #{:ok, _r_token} = AuthTokens.after_encode_and_sign(user, refresh_claims, refresh_token)
      {:ok, access_token, access_claims, refresh_token, refresh_claims}
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "正常にログアウトしました.")
    |> redirect(to: top_path(conn, :index))
  end
end
