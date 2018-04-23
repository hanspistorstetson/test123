defmodule ChatApiWeb.PageController do
  use ChatApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
