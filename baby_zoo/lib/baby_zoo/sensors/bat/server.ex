defmodule BabyZoo.Sensors.Bat.Server do
  @moduledoc """
  Listens for noise.
  """
  require Logger

  use GenServer

  alias BabyZoo.SensorTick
  alias BabyZoo.Sensors.Bat.StateMachine

  @keeper Application.get_env(:zoo, :keeper, BabyZoo.Keeper)
  @hardware Application.get_env(:zoo, :bat_hardware, BabyZoo.Sensors.Bat.Hardware)
  @impl Application.get_env(:zoo, :bat_impl, BabyZoo.Sensors.Bat.StateMachine)

  def start_link do
    GenServer.start_link(__MODULE__, :unknown)
  end

  def init(state) do
    Logger.info("Starting Server")
    pid = spawn_link(fn -> listen_for_hardware() end)
    { :ok, _ } = @hardware.start_link(pid)
    { :ok, state }
  end

  defp listen_for_hardware do
    receive do
      { :hardware_tick, direction } ->
        Logger.debug("Received #{direction} event from hardware")
        GenServer.cast(__MODULE__, direction)
    end

    listen_for_hardware()
  end

  def handle_cast(:rising, state) do
    new_state = StateMachine.next_state(state, :rising)
    tick = to_tick(new_state, direction)
    @keeper.process_sensor_tick(tick)
    { :noreply, new_state }
  end

  def handle_cast(:falling, state) do
    new_state = StateMachine.next_state(state, :falling)
    tick = to_tick(new_state, direction)
    @keeper.process_sensor_tick(tick)
    { :noreply, new_state }
  end

  defp to_tick(new_state, hardware_status) do
    SensorTick.new(:sound, new_state, DateTime.utc_now())
  end



end
