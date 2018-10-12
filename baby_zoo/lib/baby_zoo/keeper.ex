defmodule BabyZoo.Keeper do
  @moduledoc """
  Documentation for Keeper.
  """
  use GenServer

  require Logger

  def start_link(sensors) do
    GenServer.start_link(__MODULE__, sensors, name: __MODULE__)
  end

  def init(sensors) do
    sensor_pids =
      sensors
      |> Enum.map(fn s ->
        {:ok, pid} = s.start_link()
        pid
      end)
    Process.send_after(self(), :tick, 1_000)
    {:ok, %{sensors: sensor_pids, states: %{}}}
  end

  def handle_info(:tick, state) do
    Logger.debug("About to query sensors #{state.sensors}")
    new_states =
      state.sensors
      |> Enum.map(fn pid -> {pid, GenServer.call(pid, :get_current_state)} end)
      |> Map.new

    new_state = %{state | states: new_states}
      Logger.debug("Previous state #{state}, new_state #{new_state}")

    Process.send_after(self(), :tick, 1_000)

    {:noreply, }
  end

end
