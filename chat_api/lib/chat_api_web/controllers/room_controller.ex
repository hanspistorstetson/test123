defmodule ChatApiWeb.RoomController do
  use ChatApiWeb, :controller

  alias ChatApi.ChatApi
  alias ChatApi.ChatApi.Room

  action_fallback ChatApiWeb.FallbackController

  def index(conn, _params) do
    rooms = ChatApi.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, %{"room" => room_params}) do
    with {:ok, %Room{} = room} <- ChatApi.create_room(room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", room_path(conn, :show, room))
      |> render("show.json", room: room)
    end
  end

  def show(conn, %{"id" => id}) do
    room = ChatApi.get_room!(id)
    render(conn, "show.json", room: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = ChatApi.get_room!(id)

    with {:ok, %Room{} = room} <- ChatApi.update_room(room, room_params) do
      render(conn, "show.json", room: room)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = ChatApi.get_room!(id)
    with {:ok, %Room{}} <- ChatApi.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
