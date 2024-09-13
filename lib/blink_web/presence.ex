defmodule BlinkWeb.Presence do
  use Phoenix.Presence,
    otp_app: :my_app,
    pubsub_server: Blink.PubSub
end
