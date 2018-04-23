defmodule ChatApi.Auth.Guardian do
  use Guardian, otp_app: :chat_api

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
	IO.inspect(claims)
	user = claims["sub"]
	|> ChatApi.ChatApi.get_user()

	{:ok, user}
  end

  # def resource_from_claims(claims) do
  #   user =
  #     claims["sub"]
  #     |> ChatApi.ChatApi.get_user!()
  #
  #   {:ok, user}
  # end
end
