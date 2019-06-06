defmodule HubWeb.PageController do
  use HubWeb, :controller
  alias Phoenix.LiveView

  def index(conn, params) do
    LiveView.Controller.live_render(conn, HubWeb.HubsView, session: %{:params => params})
  end
end
