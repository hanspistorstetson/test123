defmodule ChatApiWeb.RoomChannel do
  use ChatApiWeb, :channel
  import Ecto.Query

  def join("rooms:" <> room_id, _params, socket) do
    IO.puts("JOINING ROOM")
    room = ChatApi.Repo.get!(ChatApi.ChatApi.Room, room_id)

    page =
      ChatApi.ChatApi.Message
      |> Ecto.Query.where([m], m.room_id == ^room.id)
      |> order_by(desc: :inserted_at, desc: :id)
      |> preload(:user)
      |> ChatApi.Repo.paginate()

    response = %{
      room: Phoenix.View.render_one(room, ChatApiWeb.RoomView, "room.json"),
      messages: Phoenix.View.render_many(page.entries, ChatApiWeb.MessageView, "message.json"),
      pagination: ChatApiWeb.PaginationHelpers.pagination(page)
    }

    send(self(), :after_join)
    {:ok, response, assign(socket, :room, room)}
  end

  def handle_info(:after_join, socket) do
    ChatApiWeb.Presence.track(socket, socket.assigns.current_user.id, %{
      user: Phoenix.View.render_one(socket.assigns.current_user, ChatApiWeb.UserView, "user.json")
    })

    push(socket, "presence_state", ChatApiWeb.Presence.list(socket))
    {:noreply, socket}
  end

  def handle_in("new_message", params, socket) do
    IO.puts("IM IN HERE")

    changeset =
      socket.assigns.room
      |> Ecto.build_assoc(:messages, user_id: socket.assigns.current_user.id)
      |> ChatApi.ChatApi.Message.changeset(params)

    case ChatApi.Repo.insert(changeset) do
      {:ok, message} ->
        IO.puts("2")
        broadcast_message(socket, message)
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply,
         {:error,
          Phoenix.View.render(ChatApiWeb.ChangesetView, "error.json", changeset: changeset)}}
    end
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end

  defp broadcast_message(socket, message) do
    message = ChatApi.Repo.preload(message, :user)
    rendered_message = Phoenix.View.render_one(message, ChatApiWeb.MessageView, "message.json")
    IO.inspect(message)
    broadcast!(socket, "message_created", rendered_message)
  end
end
