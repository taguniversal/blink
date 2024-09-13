defmodule BlinkWeb.RoomChannel do
  use BlinkWeb, :channel
  alias BlinkWeb.Presence
  require UUID

  def join("room:lobby", %{}, socket) do
    send(self(), :after_join)
    user_id = UUID.uuid4()
    BlinkWeb.Endpoint.broadcast("room:lobby", "new_user", %{"user_id" => user_id})
    socket = assign(socket, :user_id, user_id)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    # Track the user presence
    Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end
