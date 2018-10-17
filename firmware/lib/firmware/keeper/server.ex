defmodule BabyZoo.Keeper.Server do
  @moduledoc """
  Documentation for Keeper.
  """
  use GenServer

  require Logger

  @tick_interval 5_000

  alias BabyZoo.Keeper.Impl

  def start_link(sensors) do
    GenServer.start_link(__MODULE__, sensors, name: __MODULE__)
  end

  def init(sensors) do
    schedule_tick()
    {:ok, %{sensors: sensors, states: %{}}}
  end

  def handle_info(:tick, state) do
    Logger.debug("About to query sensors #{inspect state.sensors}")

    new_state = Impl.fetch_sensor_states(state.sensors, state)

    Logger.debug("Previous state #{inspect state}, new_state #{inspect new_state}")

    schedule_tick()

    {:noreply, new_state}
  end

  def handle_call({:get_state}, state) do
    {:reply, state}
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, @tick_interval)
  end

end
