defmodule UiWeb.PageController do
  use UiWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _) do
    LiveView.Controller.live_render(conn, UiWeb.GithubDeployView, session: %{})
  end

end
