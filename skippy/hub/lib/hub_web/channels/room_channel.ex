defmodule Hub.RoomChannel do
  use HubWeb, :channel
  alias HubWeb.Presence
  
  def join("rooms:lobby", _, socket) do
    IO.puts("joined")
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user_id, %{
      device: "browser",
      online_at: inspect(:os.timestamp())
    })
    # push socket, "presence_state", Presence.list(socket)
    # IO.puts(inspect Presence.list(socket))
    {:noreply, socket}
  end




end
