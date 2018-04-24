defmodule ChatApiWeb.UserController do
  use ChatApiWeb, :controller

  alias ChatApi.ChatApi.User

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case ChatApi.Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _claims} = ChatApi.Auth.Guardian.encode_and_sign(user)
        new_conn = ChatApi.Auth.Guardian.Plug.sign_in(conn, user)

        new_conn
        |> put_status(:created)
        |> render(ChatApiWeb.SessionView, "show.json", user: user, jwt: jwt)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
