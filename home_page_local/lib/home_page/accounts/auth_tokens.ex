defmodule HomePage.Accounts.AuthTokens do
  use Guardian, otp_app: :home_page

  #tokenをDBに追加
  def after_encode_and_sign(resource, claims, token) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["type"], claims, token) do
      {:ok, token}
    end
  end
 #tokenの確認
  def on_verify(claims, token) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end
#tokenの破棄
  def on_revoke(claims, token) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end

end
