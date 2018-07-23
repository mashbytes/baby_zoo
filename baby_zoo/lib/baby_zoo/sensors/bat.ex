defmodule BabyZoo.Sensors.Bat do
  @moduledoc """
  Listens for noise.
  """
  require Logger

  use GenServer

  def new() do
    { :ok, pid } = GenServer.start_link(BabyZoo.Sensors.Bat.Server, :unknown)
    pid
  end

end
