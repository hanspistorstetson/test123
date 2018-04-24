defmodule ChatApi.ChatApi.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:text, :string)
    belongs_to(:room, ChatApi.ChatApi.Room)
    belongs_to(:user, ChatApi.ChatApi.User)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
