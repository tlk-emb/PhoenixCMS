defmodule HomePage.Email do
  use Bamboo.Phoenix, view: HomePage.EmailView


  def hello_email(email) do
    home_page_mail = "home.page.phoenix0405@gmail.com"
    new_email
    |> to(email)
    |> from(home_page_mail)
    |> subject("Welcome!")
    |> text_body("Welcome to HomePage!?")
  end

  def reset_password(token, email, name) do
    home_page_mail = "home.page.phoenix0405@gmail.com"
    url = "http://localhost:4000/password_reset/"
    new_email
    |> to(email)
    |> from(home_page_mail)
    |> subject("パスワードの再設定")
    |> text_body(reset_text(name, url <> token))
  end

  defp reset_text(name, url) do
    "#{name}　様
    ホームページのパスワードの再設定リクエストを受け付けました。
    以下のURLから、フォームにシークレットキーを入力し、
    パスワードを再設定してください。
    (期限は1時間です。期限が切れた場合、再度リクエストしてください)
    URL：#{url}"
  end

end
