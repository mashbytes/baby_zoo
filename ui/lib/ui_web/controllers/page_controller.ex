defmodule UIWeb.PageController do
  use UIWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
