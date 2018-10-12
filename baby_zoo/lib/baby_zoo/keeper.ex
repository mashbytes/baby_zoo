defmodule BabyZoo.Keeper do
  @moduledoc """
  Documentation for Keeper.
  """
  use GenServer

  require Logger

  def start do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, bat_pid} = BabyZoo.Sensors.Bat.Hardware.start_link()
    Process.send_after(self(), :tick, 1_000)
    {:ok, %{sensors: [bat_pid], states: %{}}}
  end

  def handle_info(:tick, state) do
    Logger.debug("About to query sensors #{state.sensors}")
    new_states =
      state.sensors
      |> Enum.map(fn pid -> {pid, BabyZoo.Sensor.get_current_state()} end)
      |> Map.new

    new_state = %{state | states: new_states}
      Logger.debug("Previous state #{state}, new_state #{new_state}")

    Process.send_after(self(), :tick, 1_000)

    {:noreply, }
  end

end
