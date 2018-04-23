defmodule ChatApiWeb.UserView do
  use ChatApiWeb, :view
  alias ChatApiWeb.UserView

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
