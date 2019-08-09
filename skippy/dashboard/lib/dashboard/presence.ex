defmodule Dashboard.Presence do
  use Phoenix.Presence, otp_app: :dashboard,
                        pubsub_server: Dashboard.PubSub
end
