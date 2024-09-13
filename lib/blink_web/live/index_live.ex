defmodule BlinkWeb.IndexLive do
  use Phoenix.LiveView
  alias Phoenix.PubSub
  require Logger

  def mount(_params, session, socket) do
    if connected?(socket), do: PubSub.subscribe(Blink.PubSub, "room:lobby")
    if connected?(socket), do: PubSub.subscribe(Blink.PubSub, "tick")
    Logger.info("Session data: #{inspect(session)}")

    socket =
      if !Map.has_key?(socket, :user_id) do
        assign(socket, :user_id, nil)
      else
        socket
      end

    socket = assign(socket, background: "bg-black")
    {:ok, socket}
  end

  def handle_info(%{event: "tick", payload: %{"state" => tick_state}}, socket) do
    Logger.info("Live view received tick #{inspect tick_state}")
    {:ok, socket}
  end

  def handle_info(%{event: "new_user", payload: %{"user_id" => user_id}}, socket) do
    # Update the socket with the new user_id if necessary
    socket = assign(socket, :user_id, user_id)
    {:noreply, socket}
  end

  def handle_info(%{state: %{state: new_state}}, socket) do
    Logger.info ("Live view received new state: #{inspect new_state}")
    new_color = if socket.assigns.background == "bg-black", do: "bg-yellow-200", else: "bg-black"
    socket = assign(socket, :background, new_color)
    {:noreply, socket}
  end

  def handle_info(message, socket) do
    Logger.warn("Unhandled message: #{inspect(message)}")
    # Catch-all clause for unhandled messages
    {:noreply, socket}
  end
end
