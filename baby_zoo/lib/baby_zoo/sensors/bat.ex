defmodule BabyZoo.Sensors.Bat do
  @moduledoc """
  Listens for noise.
  """
  require Logger

  use GenServer

  alias BabyZoo.Sensors.Bat.Server

  def new() do
    { :ok, pid } = Server.start_link()
    pid
  end

end
