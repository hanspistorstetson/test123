defmodule ChatApiWeb.SessionController do
  use ChatApiWeb, :controller

  import Ecto.Query
  alias ChatApi.Auth.Auth

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    Auth.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def login_reply({:error, error}, conn) do
    conn
    |> put_status(:unauthorized)
    |> render("error.json")
  end

  def login_reply({:ok, user}, conn) do
    {:ok, jwt, _claims} = ChatApi.Auth.Guardian.encode_and_sign(user)
    new_conn = ChatApi.Auth.Guardian.Plug.sign_in(conn, user)

    new_conn
    |> render("show.json", user: user, jwt: jwt)

    # conn
    # |> Guardian.Plug.sign_in(user)

    # jwt = Guardian.Plug.current_token(new_conn)

    # new_conn
    # |> render("show.json", user: user, jwt: jwt)
  end

  def delete(conn, _) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, _claims} = ChatApi.Auth.Guardian.revoke(jwt)

    conn
    |> put_status(:ok)
    |> render("delete.json")
  end

  def refresh(conn, _params) do
    user = ChatApi.Auth.Guardian.Plug.current_resource(conn)
    jwt = ChatApi.Auth.Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.current_claims(conn)

    case ChatApi.Auth.Guardian.refresh(jwt) do
      {:ok, new_jwt, _new_claims} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user, jwt: new_jwt)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("forbidden.json", error: "Not authenticated")
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(ChatApiWeb.SessionView, "forbidden.json", error: "Not authenticated")
  end

  defp authenticate_user(username, given_password) do
    query = Ecto.Query.from(u in ChatApi.ChatApi.User, where: u.username == ^username)

    ChatApi.Repo.one(query)
    |> check_password(given_password)
  end

  defp check_password(nil, _), do: {:error, "Incorrect username or password"}

  defp check_password(user, given_password) do
    case Comeonin.Bcrypt.checkpw(given_password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end
end
