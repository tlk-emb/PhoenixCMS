defmodule HomePage.Accounts.Guardian do
  use Guardian, otp_app: :home_page
  alias HomePage.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_resource_id}
  end

  def resource_from_claims(claims) do
    user = claims["sub"]
    |> Accounts.get_user!
    {:ok, user}
    # If something goes wrong here return {:error, reason}
  end

  def resource_from_claims(_), do: {:error, :invalid_claims}

end
