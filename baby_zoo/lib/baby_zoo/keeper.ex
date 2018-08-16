defmodule BabyZoo.Keeper do
  @moduledoc """
  Documentation for Keeper.
  """
  use GenServer

  require Logger

  alias BabyZoo.SensorTick

  def start do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def process_sensor_tick(tick) do
    GenServer.cast(__MODULE__, tick)
  end

  def handle_cast(%SensorTick{ state: :ok} = tick, _) do
    Logger.debug("#{:tick} is #{tick}")
    {:noreply, []}
  end

  def handle_cast(%SensorTick{ state: :warning} = tick, _) do
    Logger.debug("#{:state} is #{tick}")
    {:noreply, []}
  end

  def handle_cast(%SensorTick{ state: :critical} = tick, _) do
    Logger.debug("#{:state} is #{tick}")
    {:noreply, []}
  end


end
