defmodule ChatApiWeb.SessionView do
  use ChatApiWeb, :view

  def render("show.json", %{user: user, jwt: jwt}) do
    IO.puts("ehre")

    %{
      data: render_one(user, ChatApiWeb.UserView, "user.json"),
      meta: %{token: jwt}
    }
  end

  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end
