defmodule HubWeb.HubsView do
  use Phoenix.LiveView

  alias HubWeb.Presence
  alias Phoenix.Socket.Broadcast


  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <table>
        <%= for {user_key, %{metas: metas}} <- assigns[:users] do %>
        <tr>
          <td><%= user_key %> (<%= length(metas) %>)</td>
        </tr>
        <% end %>
        </table>
      </div>
    </div>
    """
  end

  def mount(%{params: %{"name" => name}}, socket) do
    Phoenix.PubSub.subscribe(Hub.PubSub, "users")
    Presence.track(self(), "users", name, %{})
    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, %{
      users: Presence.list("users")
    })
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply, fetch(socket)}
  end

end