defmodule ChatApi.Auth.AuthAccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :chat_api,
    error_handler: ChatApi.Auth.AuthErrorHandler,
    module: ChatApi.Auth.Guardian

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
