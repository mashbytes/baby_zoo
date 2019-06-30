defmodule Bat.Broadcaster do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    schedule_initial_job()
    {:ok, nil}
  end

  def handle_info(:tick, state) do
    s = Bat.Sensor.snapshot()
    Logger.debug("Ticking with state #{s}")
    DeviceBus.dispatch(Bat, s)
    schedule_next_job()
    {:noreply, state}
  end

  defp schedule_initial_job() do
    Process.send_after(self(), :tick, 5_000) # In 5 seconds
  end

  defp schedule_next_job() do
    Process.send_after(self(), :tick, 0) # In 60 seconds
  end
end
