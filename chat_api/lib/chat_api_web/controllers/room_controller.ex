defmodule ChatApiWeb.RoomController do
  use ChatApiWeb, :controller

  alias ChatApi.ChatApi.Room
  alias ChatApi.Repo

  def index(conn, _params) do
    rooms = Repo.all(Room)
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, params) do
    current_user = ChatApi.Auth.Guardian.Plug.current_resource(conn)
    changeset = Room.changeset(%Room{}, params)

    case Repo.insert(changeset) do
      {:ok, room} ->
        assoc_changeset =
          ChatApi.ChatApi.UserRoom.changeset(%ChatApi.ChatApi.UserRoom{}, %{
            user_id: current_user.id,
            room_id: room.id
          })

        Repo.insert(assoc_changeset)

        conn
        |> put_status(:created)
        |> render("show.json", room: room)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = ChatApi.Auth.Guardian.Plug.current_resource(conn)
    room = Repo.get(Room, room_id)

    changeset =
      ChatApi.ChatApi.UserRoom.changeset(%ChatApi.ChatApi.UserRoom{}, %{
        room_id: room_id,
        user_id: current_user.id
      })

    case Repo.insert(changeset) do
      {:ok, _user_room} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{room: room})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
