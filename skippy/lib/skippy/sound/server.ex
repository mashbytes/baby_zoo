defmodule Skippy.Sound.Server do
    
  use GenServer

  require Logger

  @input_pin Application.get_env(:zoo, :sound_input_pin, 4)

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.debug("Starting hardware on pin #{@input_pin}")
    {:ok, gpio} = Circuits.GPIO.open(@input_pin, :input)
    {:ok} = Circuits.GPIO.set_interrupts(gpio, :both)
    {:ok, state}
  end

  def handle_info({:gpio_interrupt, @input_pin, direction}, state) do
    Logger.debug("Received interrupt on #{@input_pin}, direction #{direction}, state #{state}")

    # new_state = Impl.next_state(state, direction)
    # Logger.debug("Received interrupt direction #{direction}, prev state #{inspect state} new state #{inspect new_state}")
    {:noreply, state}
  end

end