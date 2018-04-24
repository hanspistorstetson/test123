defmodule ChatApiWeb.MessageController do
  use ChatApiWeb, :controller
  import Ecto.Query

  def index(conn, params) do
    last_seen_id = params["last_seen_id"] || 0
    room = ChatApi.Repo.get!(ChatApi.ChatApi.Room, params["room_id"])

    page =
      ChatApi.ChatApi.Message
      |> Ecto.Query.where([m], m.room_id == ^room.id)
      |> Ecto.Query.where([m], m.id < ^last_seen_id)
      |> Ecto.Query.order_by(desc: :inserted_at, desc: :id)
      |> Ecto.Query.preload(:user)
      |> ChatApi.Repo.paginate()

    render(conn, "index.json", %{
      messages: page.entries,
      pagination: ChatApiWeb.PaginationHelpers.pagination(page)
    })
  end
end
