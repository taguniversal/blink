defmodule Blink.Blinker do
  use GenServer
  alias Phoenix.PubSub
  require Logger

  def init(arg) do
    Logger.info("Blink init")
    schedule_message()
    {:ok, %{state: 0}}
  end

  def handle_info(:tick, state) do
    new_state = Map.update(state, :state, 1, fn s -> if s == 0, do: 1, else: 0 end)
    Logger.info("Blink state: #{inspect(new_state)}")
    PubSub.broadcast(Blink.PubSub, "tick", %{state: new_state})
    schedule_message()
    {:noreply, new_state}
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def schedule_message() do
    Process.send_after(self(), :tick, 500)
  end
end
