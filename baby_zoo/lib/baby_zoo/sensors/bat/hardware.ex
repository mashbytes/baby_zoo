defmodule BabyZoo.Sensors.Bat.Hardware do

  @behaviour BabyZoo.Sensor

  require Logger

  use GenServer

  alias GpioRpi
  alias BabyZoo.Sensors.Bat.StateMachine

  @input_pin Application.get_env(:zoo, :bat_hardware_input_pin, 4)

  def start_link() do
    GenServer.start_link(__MODULE__, BabyZoo.SensorState.new(:sound, :unknown, DateTime.utc_now()))
  end

  def init(state) do
    Logger.debug("Starting hardware on pin #{@input_pin}")
    {:ok, pid} = GpioRpi.start_link(@input_pin, :input)
    GpioRpi.set_mode(pid, :down)
    GpioRpi.set_int(pid, :both)
    {:ok, state}
  end

  def handle_info({:gpio_interrupt, @input_pin, direction}, state) do
    new_level = StateMachine.next_level(state.level, direction)
    Logger.debug("Received interrupt direction #{direction}, prev level #{state.level} new level #{new_level}")
    new_since = calculate_since(state.level, new_level, state.since)
    new_state = %{state | level: new_level, since: new_since}
    {:noreply, new_state}
  end

  def handle_call(:get_current_state, _from, state) do
    { :reply, state, state }
  end

  defp calculate_since(level, level, since) do
    since
  end

  defp calculate_since(_, _, _) do
    DateTime.utc_now()
  end

  def get_current_state() do
    GenServer.call(__MODULE__, :get_current_state)
  end

end
