defmodule BabyZoo.Sensors.Bat.Hardware do

  require Logger

  use GenServer

  alias BabyZoo.Sensors.Bat.StateMachine

  @input_pin Application.get_env(:zoo, :bat_hardware_input_pin, 4)

  def init(state) do
    Logger.debug("Starting hardware on pin #{@input_pin}")
    {:ok, pid} = GpioRpi.start_link(@input_pin, :input)
    GpioRpi.set_mode(pid, :down)
    GpioRpi.set_int(pid, :both)
    {:ok, state}
  end

  def handle_info({:gpio_interrupt, @input_pin, direction}, state) do
    new_state = StateMachine.next_state(state, direction)
    Logger.debug("Received interrupt direction #{direction}, prev state #{inspect state} new state #{inspect new_state}")
    {:noreply, new_state}
  end

  def handle_call(:get_current_state, _from, state) do
    {:reply, state, state}
  end

end
