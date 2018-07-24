defmodule BabyZoo.Sensors.Bat.Server do
  @moduledoc """
  Listens for noise.
  """
  require Logger

  use GenServer

  alias BabyZoo.Sensors.Bat.Impl
  alias BabyZoo.Sensors.Bat.Hardware

  @keeper Application.get_env(:zoo, :keeper, BabyZoo.Keeper)
  @hardware Application.get_env(:zoo, :bat_hardware, BabyZoo.Sensors.Bat.Hardware)

  def start_link do
    GenServer.start_link(__MODULE__, :unknown)
  end

  def init(state) do
    Logger.info("Starting Server")
    pid = spawn_link(fn -> listen_for_hardware_updates() end)
    { :ok, _ } = @hardware.start_link(pid)
    { :ok, state }
  end

  defp listen_for_hardware_updates do
    receive do
      { :hardware_state_update, state } ->
        Logger.debug("Received #{state} event from hardware")
        GenServer.cast(__MODULE__, state)
    end

    listen_for_hardware_updates()
  end

  def handle_cast(:rising, state) do
    new_state = Impl.determine_state(state, direction)
    @keeper.sensor_state_changed({:type, :sound, :state, new_state)
    { :noreply, new_state }
  end

  def handle_cast(:falling, state) do
    new_state = Impl.determine_state(state, direction)
    @keeper.sensor_state_changed({:type, :sound, :state, new_state)
    { :noreply, new_state }
  end

end
