defmodule BabyZoo.Keeper.Server do
  @moduledoc """
  Documentation for Keeper.
  """
  use GenServer

  require Logger

  @tick_interval 5_000

  def init(sensors) do
    schedule_tick()
    {:ok, %{sensors: sensors, states: %{}}}
  end

  def handle_info(:tick, state) do
    Logger.debug("About to query sensors #{inspect state.sensors}")
    new_states =
      state.sensors
      |> Enum.map(fn sensor -> {sensor, sensor.get_current_state()} end)
      |> Map.new

    new_state = %{state | states: new_states}
      Logger.debug("Previous state #{inspect state}, new_state #{inspect new_state}")

    schedule_tick()

    {:noreply, new_state}
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, @tick_interval)
  end

end
